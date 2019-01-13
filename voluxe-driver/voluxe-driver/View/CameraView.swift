//
//  CameraView.swift
//  voluxe-driver
//
//  Created by Christoph on 12/24/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import AVFoundation
import Foundation
import UIKit

class CameraView: UIView {

    enum OptionError {
        case faceRequiredButNotDetected
    }

    // MARK: Data

    /// The captured image.  This could be nil if an OptionError
    /// occurred during capture.
    private var _image: UIImage? {
        didSet {
            guard self.showTakenPhoto else { return }
            self.imageView.image = image
        }
    }

    /// Read-only property of the captured image.
    var image: UIImage? { return self._image }

    /// The captured image cropped based on cropTopLeft.  If not set
    /// then this will be nil.  Note that there is potential for a
    /// crop to be applied incorrectly if cropTopLeft is changed
    /// after capture() is called.
    private var _croppedImage: UIImage?
    var croppedImage: UIImage? { return self._croppedImage }

    // Possible error that might have occurred during and
    // after image capture.  Note that this DOES NOT forward
    // lower level AVFoundation errors, these errors are specific
    // to the CameraView implementation and options.
    private var error: OptionError?

    // Defines which device camera (front or back).  Can only
    // be set with the CameraView is inited.
    private let position: AVCaptureDevice.Position

    // Generated rectangle when cropTopLeft is set.  This is
    // used to crop a captured image and update the cropLayoutGuide.
    private var cropRect: CGRect?

    // Still photo only capture session.  This view would require
    // additional changes to capture video.
    private let session: AVCaptureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = AVCaptureSession.Preset.photo
        return session
    }()

    // Handle for captured photo output.
    private let output = AVCapturePhotoOutput()

    // MARK: Layout

    // The real-time camera preview.
    private let preview = UIView()

    // The image view used to present the resulting photo.  Will
    // only be used if showTakenPhoto is set.
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    // Note that the crop view fills the entire camera view.
    // The crop rect applies to the inner rectangle where
    // this view is masked away.  Hence, the crop layout guides
    // do not follow this view, but rather the generated crop rect.
    private let cropView: UIView = {
        let effect = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: effect)
        return view
    }()

    // Updated in layoutSubviews()
    let cropLayoutGuide: UILayoutGuide = {
        let guide = UILayoutGuide()
        return guide
    }()

    // MARK: Options

    /// Presents the captured image on top of the live camera
    /// view after a photo has been taken.
    var showTakenPhoto: Bool = false

    /// Tells the capture session to use flash or not.
    var useFlash: Bool = true

    /// Using a top left inset, a circular crop will appear
    /// over the camera preview.  This will also produce a
    /// square cropped image in addition to the camera image.
    var cropTopLeft: CGPoint? {
        didSet {
            self.updateCropView()
        }
    }

    /// Changes the color of the crop overlay.  The overlay
    /// is stylized in the typical iOS blurred fashion, but
    /// can be colorized using this property.  If the overlay
    /// is not appearing, make sure both the top left and color
    /// are set.
    var cropColor: UIColor? {
        didSet {
            self.cropView.backgroundColor = cropColor
        }
    }

    /// This will return a nil image and a flag if set
    /// and a face was not captured in the camera image.
    var requireFaceDetection: Bool = false

    // MARK: Lifecycle

    init(position: AVCaptureDevice.Position = .back) {
        self.position = position
        super.init(frame: CGRect.zero)
        self.addSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        self.session.stopRunning()
    }

    private func addSubviews() {
        self.backgroundColor = .black
        self.addLayoutGuide(self.cropLayoutGuide)
        Layout.fill(view: self, with: self.preview, useSafeArea: false)
        Layout.fill(view: self, with: self.imageView, useSafeArea: false)
        Layout.fill(view: self, with: self.cropView, useSafeArea: false)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateCropView()
        guard let layer = self.preview.layer.sublayers?.first else { return }
        layer.frame = self.preview.bounds
    }

    private func updateCropView() {

        guard let point = self.cropTopLeft else {
            self.cropView.layer.mask = nil
            return
        }

        guard self.bounds.size.width > 0 else { return }

        let layer = CAShapeLayer()
        layer.frame = self.cropView.bounds
        layer.fillRule = CAShapeLayerFillRule.evenOdd
        let path = UIBezierPath(rect: layer.bounds)
        let width = self.bounds.size.width - (point.x * 2)
        let rect = CGRect(x: point.x,
                          y: point.y,
                          width: width,
                          height: width)
        path.append(UIBezierPath(ovalIn: rect))
        layer.path = path.cgPath
        self.cropView.layer.mask = layer
        self.cropRect = rect

        // update the crop layout guide to match the crop rect
        self.cropLayoutGuide.topAnchor.constraint(equalTo: self.topAnchor, constant: rect.origin.y).isActive = true
        self.cropLayoutGuide.leftAnchor.constraint(equalTo: self.leftAnchor, constant: rect.origin.x).isActive = true
        self.cropLayoutGuide.widthAnchor.constraint(equalToConstant: rect.size.width).isActive = true
        self.cropLayoutGuide.heightAnchor.constraint(equalToConstant: rect.size.height).isActive = true
    }

    /// Configures the capture session to the current device.  Note that this
    /// is an expensive operation, so it should NOT be done before using this
    /// view in an animation or transition.
    func open(animated: Bool = true) {

        guard self.session.isRunning == false else { return }
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                   for: AVMediaType.video,
                                                   position: self.position) else { return }
        guard let input = try? AVCaptureDeviceInput(device: device) else { return }
        guard self.session.canAddInput(input) else { return }
        guard self.session.canAddOutput(self.output) else { return }

        self.session.addInput(input)
        self.session.addOutput(self.output)

        let layer = AVCaptureVideoPreviewLayer(session: self.session)
        layer.contentsGravity = .resizeAspectFill
        layer.videoGravity = .resizeAspectFill
        self.preview.layer.addSublayer(layer)
        layer.frame = self.preview.bounds
        self.session.startRunning()

        UIView.animate(withDuration: animated ? 0.5 : 0) {
            self.preview.alpha = 1
            self.imageView.alpha = 1
        }
    }

    /// Hide the preview and taken photo views.  Suitable to be
    /// called before transitioning the parent view controller.
    /// Currently calling open() after close() is not supported,
    /// the UI and session will not be restored correctly.
    func close() {
        UIView.animate(withDuration: 0.2) {
            self.preview.alpha = 0
            self.imageView.alpha = 0
        }
    }

    // MARK: Image capture and reset

    func capture() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = self.useFlash ? AVCaptureDevice.FlashMode.on : AVCaptureDevice.FlashMode.off
        self.output.capturePhoto(with: settings, delegate: self)
    }

    func reset() {
        self._image = nil
        self._croppedImage = nil
        self.imageView.image = nil
    }

    // MARK: Notifications

    var photoWillBeTaken: (() -> ())?
    var photoWasTaken: ((UIImage?, OptionError?) -> ())?

    // Returns the cropped image (if option set) or original image
    private func notifyPhotoWasTaken() {
        self.photoWasTaken?(self.croppedImage ?? self.image, self.error)
    }
}

// MARK:- Extension for capture delegate

extension CameraView: AVCapturePhotoCaptureDelegate {

    func photoOutput(_ output: AVCapturePhotoOutput,
                     willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings)
    {
        self.photoWillBeTaken?()
    }

    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?)
    {
        guard let data = photo.fileDataRepresentation() else { return }
        guard let image = UIImage(data: data) else { return }
        let flipped = self.flipImageIfNecessary(image)
        let cropped = self.cropImageIfNecessary(flipped)
        if self.requireFaceDetection && self.imageHasSingleFace(cropped) == false {
            DispatchQueue.main.async {
                self._image = nil
                self._croppedImage = nil
                self.error = .faceRequiredButNotDetected
                self.notifyPhotoWasTaken()
            }
        } else {
            DispatchQueue.main.async {
                self._image = flipped
                self._croppedImage = cropped
                self.error = nil
                self.notifyPhotoWasTaken()
            }
        }
    }

    private func imageHasSingleFace(_ image: UIImage?) -> Bool {
        guard let cgImage = image?.cgImage else { return false }
        let image = CIImage(cgImage: cgImage)
        let context = CIContext()
        let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let detector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: options)
        guard let features = detector?.features(in: image, options: [:]) else { return false }
        guard features.count == 1 else { return false }
        guard let feature = features.first as? CIFaceFeature else { return false }
        return feature.hasLeftEyePosition && feature.hasRightEyePosition && feature.hasMouthPosition
    }

    /// Flips the specified image based on the AVCaptureDevice.Position
    /// specified when the camera was opened.  It is likely that this is
    /// NOT exhaustive enough if the CameraView is being used in an app
    /// that allows orientation changes, however for portrait orientation
    /// this works as expected.
    private func flipImageIfNecessary(_ image: UIImage) -> UIImage {
        guard self.position == AVCaptureDevice.Position.front else { return image }
        guard let cgImage = image.cgImage else { return image }
        return UIImage(cgImage: cgImage, scale: image.scale, orientation: .leftMirrored)
    }

    /// Crops the image returned from the capture output based on
    /// the set crop top left (which internally generates a crop rectangle).
    /// If there is no crop set or processing fails, nil is returned.
    private func cropImageIfNecessary(_ image: UIImage) -> UIImage? {
        guard let rect = self.cropRect else { return nil }
        let ratio = image.size.height / self.bounds.size.height
        let y = rect.origin.y * ratio
        let height = rect.size.height * ratio
        let x = (image.size.width / 2) - (height / 2)
        let cropRect = CGRect(x: x, y: y, width: height, height: height)
        UIGraphicsBeginImageContextWithOptions(cropRect.size, false, image.scale)
        let origin = CGPoint(x: -cropRect.origin.x, y: -cropRect.origin.y)
        image.draw(at: origin)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return result
    }
}
