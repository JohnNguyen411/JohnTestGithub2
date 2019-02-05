//
//  LocalizedTemplate.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 1/30/19.
//  Copyright © 2019 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

/**
 Usage:
 Localized.loadError
 Localized.welcomeMessage.with("Dan")
 */

enum Localized: CustomStringConvertible {
    
    class Bundles {
        static let framework = Bundle(for: Localized.Bundles.self)
    }
    
    case popupAlreadyStartedDrivingPositive
	case permissionsLocationDeniedMessage
	case viewScheduleServiceTypeOtherUnknown
	case popupDeviceChangeMessage
	case errorForcedUpgradeTitle
	case popupSelectTimeSlotUnavailableCallDealership
	case popupDeviceChangeTitle
	case viewSigninPopupProgressSignin
	case popupSoftUpgradeNegative
	case viewContactCall
	case loading
	case viewDriveto
	case viewDrawerProfileOptionsSignout
	case viewInspectLoanerMinPhotoWarning
	case viewIntro
	case signout
	case viewScheduleListItemTypeDeliver
	case viewSignin
	case notificationForegroundServiceTextDriverInspectLoaner
	case viewExchangeKeysSwipeButtonTitle
	case notificationBatteryWarningText
	case errorInvalidPassword
	case permissionsCameraDeniedMessage
	case yes
	case errorInvalidPhoneVerificationCode
	case viewInspectCustomerOverlayInfo
	case viewScheduleEmpty
	case notificationForegroundServiceTextDriverInspectDocuments
	case passwordRequirements
	case viewArrivedat
	case appName
	case viewReturntoSwipeButtonTitle
	case errorAccountAlreadyExists
	case number11
	case popupForgotPasswordMessage
	case min
	case viewGettoCustomerSwipeButtonTitle
	case viewRetrieveVehicleCustomerSwipeTitle
	case viewScheduleCurrent
	case viewTosContentPrivacyPolicyTitle
	case popupMileageMinConfirmation
	case viewSigninPhoto
	case errorLocationOutOfPickupArea
	case viewScheduleServiceStatusSelfFooterTitleDropoff
	case keyCodeColon
	case viewInspectNotesSwipeButtonTitle
	case popupGetToDealershipCopyToClipboard
	case viewScheduleServiceStatusSelfAdvisorPickup
	case exchangeKeys
	case viewReceiveVehicleCustomerSwipeButtonTitle
	case viewTosContentTermsOfServiceTitle
	case popupHardRefreshTitle
	case licensePlateColon
	case error
	case viewExchangeKeysPickupSwipeTitle
	case viewContactText
	case viewIntroFooterSignin
	case vehicleMake
	case viewHelpCategoryHowLuxeByVolvoWorks
	case viewLogoTitle
	case dealership
	case retry
	case number8
	case notificationForegroundServiceTextDriverVehicleToCustomer
	case errorFaceDetectionMessage
	case color
	case viewScheduleListHeaderNameCompletedToday
	case errorInvalidCredentials
	case helpIForgotMyPassword
	case done
	case popupUpdatingLocation
	case viewEmailIntentChooserTitle
	case loanerColon
	case viewScheduleServiceStatusSelfDealershipNavigate
	case errorSoftUpgradeTitle
	case viewReceiveVehicleLoanerNext
	case viewScheduleListItemTypePickup
	case viewDrawerProfileOptionsChangeContact
	case resendCode
	case viewStartRequestRetrieveCustomerVehicle
	case close
	case popupTooFarFromCustomerMessage
	case popupAlreadyStartedDrivingMessage
	case errorInvalidLastName
	case iAmSure
	case inspectVehicle
	case errorUnknown
	case notesColon
	case later
	case goBack
	case viewScheduleState
	case notificationForegroundServiceTextRetrieveVehicle
	case viewDrawerContactDealershipText
	case helpICantUpdateMyPhone
	case help
	case viewInspectDocumentsMinPhotosWarning
	case openSettings
	case confirmPhoneNumber
	case viewArrivedatCustomer
	case viewSigninForgotPassword
	case errorLocationOutOfDropoffArea
	case number7
	case popupGetToCustomerCopyToClipboard
	case number6
	case viewSigninActionSignin
	case viewDrawerProfileOptionsChangePassword
	case createPassword
	case settings
	case phoneNumberCannotBeEmpty
	case skip
	case viewTosContentPrivacyPolicy
	case requestCanceled
	case number9
	case errorInvalidFirstName
	case phoneNumberAlreadyTaken
	case viewInspectDocuments
	case newPassword
	case cancel
	case viewDrawerNavigationPreferenceTitle
	case add
	case viewStartRequestRetrieveForms
	case model
	case errorInvalidEmail
	case back
	case popupTooFarFromDealershipTitle
	case viewRetrieveVehicleLoaner
	case viewRecordLoanerMileageDropoffSwipeButtonTitle
	case viewHelpCategoryTroubleWithLuxeByVolvoApp
	case errorIllegalRequestStateChange
	case pickupColon
	case errorDuplicateLoanerVehicleBookingAssignment
	case yourAccount
	case readMore
	case inspectVehicles
	case dismiss
	case viewExchangeKeysDeliverySwipeTitle
	case viewDrawerContactDealershipCall
	case viewHelpOptionDetailEmailDealer
	case number5
	case notificationForegroundServiceTextDriverGetToCustomer
	case notNow
	case viewNavigateWazeText
	case modelColon
	case viewRetrieveFormsSwipeTitle
	case errorEnterLoanerMileage
	case viewInspectDocumentsOverlayInfo
	case confirmNewPassword
	case viewGettoCustomer
	case viewPhoneAddLabel
	case viewArrivedatDeliveryInspectVehicles
	case errorForcedUpgradeMessage
	case password
	case notificationForegroundServiceTextInspectNotes
	case notificationForegroundServiceTextReceiveLoaner
	case mins
	case popupChooseDealershipTitle
	case errorAmbiguousVehicleUpsert
	case ok
	case update
	case viewExchangeKeysInfoReminder
	case notificationForegroundServiceTextDriverLoanerToCustomer
	case viewGetToText
	case errorPhoneNumberTaken
	case viewSoftwareLicences
	case popupTooFarFromCustomerPositive
	case popupGetToDealershipTitle
	case errorOffline
	case viewHelpOptionDetailCallDealer
	case viewRetrieveForms
	case viewInspectCustomer
	case viewArrivedatDeliverySwipeButtonTitle
	case viewStartRequestDropoff
	case pickup
	case viewDrawerNavigationPreferenceWaze
	case viewRetrieveVehicleCustomer
	case notificationForegroundServiceTextDriveLoanerToDealership
	case popupHardRefreshMessage
	case viewGettoCustomerArriveatCustomer
	case repairOrderColon
	case errorIllegalRequestTaskChange
	case viewReceiveVehicleCustomer
	case no
	case viewReceiveVehicleLoanerSwipeButtonTitle
	case phoneNumber
	case viewEmailSubject
	case errorSoftUpgradeMessage
	case popupTooFarFromCustomerTitle
	case popupTooFarFromDealershipMessage
	case customerColon
	case contact
	case viewStartRequestSwipeButtonTitle
	case viewDrawerProfileOptionsAttributions
	case viewHelpOptionDetailEmailVolvo
	case viewReceiveVehicleInfoReminder
	case requestCompleted
	case viewScheduleEmptyToday
	case viewSwipeButtonInnerText
	case viewInspectLoanerOverlayInfo
	case viewPhoneAdd
	case viewScheduleListHeaderNameUpcomingToday
	case remove
	case exchangeKey
	case notificationForegroundServiceTextDriverMeetWithCustomer
	case viewScheduleStateRefreshButton
	case volvoYearModel
	case popupSignoutConfirmationMessage
	case viewRetrieveVehicle
	case notificationForegroundServiceTextGetToDealership
	case errorInvalidApplicationVersion
	case notificationForegroundServiceTitle
	case viewInspectDocumentsMinPhotoWarning
	case number2
	case errorInvalidPhoneNumber
	case errorLocationServiceUnavailable
	case viewTosContentTermsOfServiceUrl
	case serviceColon
	case viewInspectNotes
	case recentMileageColon
	case errorLocationServiceNotOfferedInYourArea
	case change
	case viewRetrieveFormsInfoNext
	case errorRequestNotCancelable
	case popupPhoneVerificationResendCodeTitle
	case notificationForegroundServiceTextRecordLoanerMileage
	case viewScheduleListHeaderNameCurrent
	case requestReset
	case errorAmbiguousCustomerUpsert
	case viewReceiveVehicle
	case new
	case notificationForegroundServiceTextDriverExchangeKeys
	case viewDrivetoCustomer
	case errorInvalidVerificationCode
	case popupPhoneVerificationResendCodeMessage
	case number1
	case viewInspectNotesDescriptionHint
	case year
	case updateNow
	case errorOnline
	case returnToDealership
	case number4
	case notificationForegroundServiceTextRetrieveLoaner
	case notificationBatteryWarningTitle
	case viewStartRequestPickup
	case viewSigninPasswordShort
	case viewRetrieveVehicleCustomerInfoNext
	case viewReceiveVehicleLoaner
	case edit
	case deliveryColon
	case viewArrivedatPickupSwipeButtonTitle
	case viewSchedule
	case errorInvalidUserDisabled
	case notificationForegroundServiceTextDriveCustomerToDealership
	case viewPhoneVerificationLabel
	case unknown
	case notificationActionOpen
	case errorUserDisabled
	case viewSigninEmailInvalid
	case support
	case viewScheduleStateRefreshInfo
	case viewRecordLoanerMileagePickupSwipeButtonTitle
	case notAvailable
	case viewTosContent
	case viewEmailBody
	case errorInvalidPasswordUnauthorizedCharacters
	case viewRecordLoanerMileageDropoffInfoNext
	case errorInvalidPasswordConfirm
	case viewInspectCustomerMinPhotoWarning
	case next
	case popupForgotPasswordTitle
	case addressColon
	case viewDrivetoArriveatCustomer
	case confirmationCode
	case viewTosContentTermsOfService
	case viewChecklistLoanerAgreementLabel
	case viewHelpOptionDetailCallVolvo
	case delivery
	case viewProfileChangePasswordTemp
	case viewNavigateAddressCopiedToClipboard
	case popupMileageMaxConfirmation
	case notificationBatteryWarningTextBig
	case notificationForegroundServiceTextDriverInspectCustomer
	case permissionsLocationDeniedTitle
	case emailAddress
	case popupAddNewLocationLabel
	case errorRemoveVehicleError
	case viewRecordLoanerMileage
	case popupGetToCustomerTitle
	case viewStartRequestRetrieveLoaner
	case number3
	case errorOops
	case number10
	case viewInspectLoanerMinPhotosWarning
	case viewRetrieveVehicleLoanerSwipeTitle
	case viewScheduleServiceStatusSelfAdvisorDropoff
	case popupAlreadyStartedDrivingTitle
	case errorVerifyPhoneNumber
	case viewIntroFooterSignup
	case popupTooFarFromDealershipPositive
	case viewTosContentPrivacyPolicyUrl
	case viewDrivetoSwipeButtonTitle
	case requestTaskChangedFromBackend
	case notificationForegroundServiceTextRetrieveForms
	case viewGettoDealershipSwipeButtonTitle
	case viewProfileChangeContact
	case permissionsCameraDeniedTitle
	case viewDrawerNavigationPreferenceGoogle
	case viewHelpCategoryLastLeg
	case viewNavigateText
	case viewInspectLoaner
	case toastSettingsLocationDisabled
	case currentPassword
	case viewInspectCustomerMinPhotosWarning

    var key : String {
        switch self {
            case .popupAlreadyStartedDrivingPositive:
					return "popupAlreadyStartedDrivingPositive"
			case .permissionsLocationDeniedMessage:
					return "permissionsLocationDeniedMessage"
			case .viewScheduleServiceTypeOtherUnknown:
					return "viewScheduleServiceTypeOtherUnknown"
			case .popupDeviceChangeMessage:
					return "popupDeviceChangeMessage"
			case .errorForcedUpgradeTitle:
					return "errorForcedUpgradeTitle"
			case .popupSelectTimeSlotUnavailableCallDealership:
					return "popupSelectTimeSlotUnavailableCallDealership"
			case .popupDeviceChangeTitle:
					return "popupDeviceChangeTitle"
			case .viewSigninPopupProgressSignin:
					return "viewSigninPopupProgressSignin"
			case .popupSoftUpgradeNegative:
					return "popupSoftUpgradeNegative"
			case .viewContactCall:
					return "viewContactCall"
			case .loading:
					return "loading"
			case .viewDriveto:
					return "viewDriveto"
			case .viewDrawerProfileOptionsSignout:
					return "viewDrawerProfileOptionsSignout"
			case .viewInspectLoanerMinPhotoWarning:
					return "viewInspectLoanerMinPhotoWarning"
			case .viewIntro:
					return "viewIntro"
			case .signout:
					return "signout"
			case .viewScheduleListItemTypeDeliver:
					return "viewScheduleListItemTypeDeliver"
			case .viewSignin:
					return "viewSignin"
			case .notificationForegroundServiceTextDriverInspectLoaner:
					return "notificationForegroundServiceTextDriverInspectLoaner"
			case .viewExchangeKeysSwipeButtonTitle:
					return "viewExchangeKeysSwipeButtonTitle"
			case .notificationBatteryWarningText:
					return "notificationBatteryWarningText"
			case .errorInvalidPassword:
					return "errorInvalidPassword"
			case .permissionsCameraDeniedMessage:
					return "permissionsCameraDeniedMessage"
			case .yes:
					return "yes"
			case .errorInvalidPhoneVerificationCode:
					return "errorInvalidPhoneVerificationCode"
			case .viewInspectCustomerOverlayInfo:
					return "viewInspectCustomerOverlayInfo"
			case .viewScheduleEmpty:
					return "viewScheduleEmpty"
			case .notificationForegroundServiceTextDriverInspectDocuments:
					return "notificationForegroundServiceTextDriverInspectDocuments"
			case .passwordRequirements:
					return "passwordRequirements"
			case .viewArrivedat:
					return "viewArrivedat"
			case .appName:
					return "appName"
			case .viewReturntoSwipeButtonTitle:
					return "viewReturntoSwipeButtonTitle"
			case .errorAccountAlreadyExists:
					return "errorAccountAlreadyExists"
			case .number11:
					return "number11"
			case .popupForgotPasswordMessage:
					return "popupForgotPasswordMessage"
			case .min:
					return "min"
			case .viewGettoCustomerSwipeButtonTitle:
					return "viewGettoCustomerSwipeButtonTitle"
			case .viewRetrieveVehicleCustomerSwipeTitle:
					return "viewRetrieveVehicleCustomerSwipeTitle"
			case .viewScheduleCurrent:
					return "viewScheduleCurrent"
			case .viewTosContentPrivacyPolicyTitle:
					return "viewTosContentPrivacyPolicyTitle"
			case .popupMileageMinConfirmation:
					return "popupMileageMinConfirmation"
			case .viewSigninPhoto:
					return "viewSigninPhoto"
			case .errorLocationOutOfPickupArea:
					return "errorLocationOutOfPickupArea"
			case .viewScheduleServiceStatusSelfFooterTitleDropoff:
					return "viewScheduleServiceStatusSelfFooterTitleDropoff"
			case .keyCodeColon:
					return "keyCodeColon"
			case .viewInspectNotesSwipeButtonTitle:
					return "viewInspectNotesSwipeButtonTitle"
			case .popupGetToDealershipCopyToClipboard:
					return "popupGetToDealershipCopyToClipboard"
			case .viewScheduleServiceStatusSelfAdvisorPickup:
					return "viewScheduleServiceStatusSelfAdvisorPickup"
			case .exchangeKeys:
					return "exchangeKeys"
			case .viewReceiveVehicleCustomerSwipeButtonTitle:
					return "viewReceiveVehicleCustomerSwipeButtonTitle"
			case .viewTosContentTermsOfServiceTitle:
					return "viewTosContentTermsOfServiceTitle"
			case .popupHardRefreshTitle:
					return "popupHardRefreshTitle"
			case .licensePlateColon:
					return "licensePlateColon"
			case .error:
					return "error"
			case .viewExchangeKeysPickupSwipeTitle:
					return "viewExchangeKeysPickupSwipeTitle"
			case .viewContactText:
					return "viewContactText"
			case .viewIntroFooterSignin:
					return "viewIntroFooterSignin"
			case .vehicleMake:
					return "vehicleMake"
			case .viewHelpCategoryHowLuxeByVolvoWorks:
					return "viewHelpCategoryHowLuxeByVolvoWorks"
			case .viewLogoTitle:
					return "viewLogoTitle"
			case .dealership:
					return "dealership"
			case .retry:
					return "retry"
			case .number8:
					return "number8"
			case .notificationForegroundServiceTextDriverVehicleToCustomer:
					return "notificationForegroundServiceTextDriverVehicleToCustomer"
			case .errorFaceDetectionMessage:
					return "errorFaceDetectionMessage"
			case .color:
					return "color"
			case .viewScheduleListHeaderNameCompletedToday:
					return "viewScheduleListHeaderNameCompletedToday"
			case .errorInvalidCredentials:
					return "errorInvalidCredentials"
			case .helpIForgotMyPassword:
					return "helpIForgotMyPassword"
			case .done:
					return "done"
			case .popupUpdatingLocation:
					return "popupUpdatingLocation"
			case .viewEmailIntentChooserTitle:
					return "viewEmailIntentChooserTitle"
			case .loanerColon:
					return "loanerColon"
			case .viewScheduleServiceStatusSelfDealershipNavigate:
					return "viewScheduleServiceStatusSelfDealershipNavigate"
			case .errorSoftUpgradeTitle:
					return "errorSoftUpgradeTitle"
			case .viewReceiveVehicleLoanerNext:
					return "viewReceiveVehicleLoanerNext"
			case .viewScheduleListItemTypePickup:
					return "viewScheduleListItemTypePickup"
			case .viewDrawerProfileOptionsChangeContact:
					return "viewDrawerProfileOptionsChangeContact"
			case .resendCode:
					return "resendCode"
			case .viewStartRequestRetrieveCustomerVehicle:
					return "viewStartRequestRetrieveCustomerVehicle"
			case .close:
					return "close"
			case .popupTooFarFromCustomerMessage:
					return "popupTooFarFromCustomerMessage"
			case .popupAlreadyStartedDrivingMessage:
					return "popupAlreadyStartedDrivingMessage"
			case .errorInvalidLastName:
					return "errorInvalidLastName"
			case .iAmSure:
					return "iAmSure"
			case .inspectVehicle:
					return "inspectVehicle"
			case .errorUnknown:
					return "errorUnknown"
			case .notesColon:
					return "notesColon"
			case .later:
					return "later"
			case .goBack:
					return "goBack"
			case .viewScheduleState:
					return "viewScheduleState"
			case .notificationForegroundServiceTextRetrieveVehicle:
					return "notificationForegroundServiceTextRetrieveVehicle"
			case .viewDrawerContactDealershipText:
					return "viewDrawerContactDealershipText"
			case .helpICantUpdateMyPhone:
					return "helpICantUpdateMyPhone"
			case .help:
					return "help"
			case .viewInspectDocumentsMinPhotosWarning:
					return "viewInspectDocumentsMinPhotosWarning"
			case .openSettings:
					return "openSettings"
			case .confirmPhoneNumber:
					return "confirmPhoneNumber"
			case .viewArrivedatCustomer:
					return "viewArrivedatCustomer"
			case .viewSigninForgotPassword:
					return "viewSigninForgotPassword"
			case .errorLocationOutOfDropoffArea:
					return "errorLocationOutOfDropoffArea"
			case .number7:
					return "number7"
			case .popupGetToCustomerCopyToClipboard:
					return "popupGetToCustomerCopyToClipboard"
			case .number6:
					return "number6"
			case .viewSigninActionSignin:
					return "viewSigninActionSignin"
			case .viewDrawerProfileOptionsChangePassword:
					return "viewDrawerProfileOptionsChangePassword"
			case .createPassword:
					return "createPassword"
			case .settings:
					return "settings"
			case .phoneNumberCannotBeEmpty:
					return "phoneNumberCannotBeEmpty"
			case .skip:
					return "skip"
			case .viewTosContentPrivacyPolicy:
					return "viewTosContentPrivacyPolicy"
			case .requestCanceled:
					return "requestCanceled"
			case .number9:
					return "number9"
			case .errorInvalidFirstName:
					return "errorInvalidFirstName"
			case .phoneNumberAlreadyTaken:
					return "phoneNumberAlreadyTaken"
			case .viewInspectDocuments:
					return "viewInspectDocuments"
			case .newPassword:
					return "newPassword"
			case .cancel:
					return "cancel"
			case .viewDrawerNavigationPreferenceTitle:
					return "viewDrawerNavigationPreferenceTitle"
			case .add:
					return "add"
			case .viewStartRequestRetrieveForms:
					return "viewStartRequestRetrieveForms"
			case .model:
					return "model"
			case .errorInvalidEmail:
					return "errorInvalidEmail"
			case .back:
					return "back"
			case .popupTooFarFromDealershipTitle:
					return "popupTooFarFromDealershipTitle"
			case .viewRetrieveVehicleLoaner:
					return "viewRetrieveVehicleLoaner"
			case .viewRecordLoanerMileageDropoffSwipeButtonTitle:
					return "viewRecordLoanerMileageDropoffSwipeButtonTitle"
			case .viewHelpCategoryTroubleWithLuxeByVolvoApp:
					return "viewHelpCategoryTroubleWithLuxeByVolvoApp"
			case .errorIllegalRequestStateChange:
					return "errorIllegalRequestStateChange"
			case .pickupColon:
					return "pickupColon"
			case .errorDuplicateLoanerVehicleBookingAssignment:
					return "errorDuplicateLoanerVehicleBookingAssignment"
			case .yourAccount:
					return "yourAccount"
			case .readMore:
					return "readMore"
			case .inspectVehicles:
					return "inspectVehicles"
			case .dismiss:
					return "dismiss"
			case .viewExchangeKeysDeliverySwipeTitle:
					return "viewExchangeKeysDeliverySwipeTitle"
			case .viewDrawerContactDealershipCall:
					return "viewDrawerContactDealershipCall"
			case .viewHelpOptionDetailEmailDealer:
					return "viewHelpOptionDetailEmailDealer"
			case .number5:
					return "number5"
			case .notificationForegroundServiceTextDriverGetToCustomer:
					return "notificationForegroundServiceTextDriverGetToCustomer"
			case .notNow:
					return "notNow"
			case .viewNavigateWazeText:
					return "viewNavigateWazeText"
			case .modelColon:
					return "modelColon"
			case .viewRetrieveFormsSwipeTitle:
					return "viewRetrieveFormsSwipeTitle"
			case .errorEnterLoanerMileage:
					return "errorEnterLoanerMileage"
			case .viewInspectDocumentsOverlayInfo:
					return "viewInspectDocumentsOverlayInfo"
			case .confirmNewPassword:
					return "confirmNewPassword"
			case .viewGettoCustomer:
					return "viewGettoCustomer"
			case .viewPhoneAddLabel:
					return "viewPhoneAddLabel"
			case .viewArrivedatDeliveryInspectVehicles:
					return "viewArrivedatDeliveryInspectVehicles"
			case .errorForcedUpgradeMessage:
					return "errorForcedUpgradeMessage"
			case .password:
					return "password"
			case .notificationForegroundServiceTextInspectNotes:
					return "notificationForegroundServiceTextInspectNotes"
			case .notificationForegroundServiceTextReceiveLoaner:
					return "notificationForegroundServiceTextReceiveLoaner"
			case .mins:
					return "mins"
			case .popupChooseDealershipTitle:
					return "popupChooseDealershipTitle"
			case .errorAmbiguousVehicleUpsert:
					return "errorAmbiguousVehicleUpsert"
			case .ok:
					return "ok"
			case .update:
					return "update"
			case .viewExchangeKeysInfoReminder:
					return "viewExchangeKeysInfoReminder"
			case .notificationForegroundServiceTextDriverLoanerToCustomer:
					return "notificationForegroundServiceTextDriverLoanerToCustomer"
			case .viewGetToText:
					return "viewGetToText"
			case .errorPhoneNumberTaken:
					return "errorPhoneNumberTaken"
			case .viewSoftwareLicences:
					return "viewSoftwareLicences"
			case .popupTooFarFromCustomerPositive:
					return "popupTooFarFromCustomerPositive"
			case .popupGetToDealershipTitle:
					return "popupGetToDealershipTitle"
			case .errorOffline:
					return "errorOffline"
			case .viewHelpOptionDetailCallDealer:
					return "viewHelpOptionDetailCallDealer"
			case .viewRetrieveForms:
					return "viewRetrieveForms"
			case .viewInspectCustomer:
					return "viewInspectCustomer"
			case .viewArrivedatDeliverySwipeButtonTitle:
					return "viewArrivedatDeliverySwipeButtonTitle"
			case .viewStartRequestDropoff:
					return "viewStartRequestDropoff"
			case .pickup:
					return "pickup"
			case .viewDrawerNavigationPreferenceWaze:
					return "viewDrawerNavigationPreferenceWaze"
			case .viewRetrieveVehicleCustomer:
					return "viewRetrieveVehicleCustomer"
			case .notificationForegroundServiceTextDriveLoanerToDealership:
					return "notificationForegroundServiceTextDriveLoanerToDealership"
			case .popupHardRefreshMessage:
					return "popupHardRefreshMessage"
			case .viewGettoCustomerArriveatCustomer:
					return "viewGettoCustomerArriveatCustomer"
			case .repairOrderColon:
					return "repairOrderColon"
			case .errorIllegalRequestTaskChange:
					return "errorIllegalRequestTaskChange"
			case .viewReceiveVehicleCustomer:
					return "viewReceiveVehicleCustomer"
			case .no:
					return "no"
			case .viewReceiveVehicleLoanerSwipeButtonTitle:
					return "viewReceiveVehicleLoanerSwipeButtonTitle"
			case .phoneNumber:
					return "phoneNumber"
			case .viewEmailSubject:
					return "viewEmailSubject"
			case .errorSoftUpgradeMessage:
					return "errorSoftUpgradeMessage"
			case .popupTooFarFromCustomerTitle:
					return "popupTooFarFromCustomerTitle"
			case .popupTooFarFromDealershipMessage:
					return "popupTooFarFromDealershipMessage"
			case .customerColon:
					return "customerColon"
			case .contact:
					return "contact"
			case .viewStartRequestSwipeButtonTitle:
					return "viewStartRequestSwipeButtonTitle"
			case .viewDrawerProfileOptionsAttributions:
					return "viewDrawerProfileOptionsAttributions"
			case .viewHelpOptionDetailEmailVolvo:
					return "viewHelpOptionDetailEmailVolvo"
			case .viewReceiveVehicleInfoReminder:
					return "viewReceiveVehicleInfoReminder"
			case .requestCompleted:
					return "requestCompleted"
			case .viewScheduleEmptyToday:
					return "viewScheduleEmptyToday"
			case .viewSwipeButtonInnerText:
					return "viewSwipeButtonInnerText"
			case .viewInspectLoanerOverlayInfo:
					return "viewInspectLoanerOverlayInfo"
			case .viewPhoneAdd:
					return "viewPhoneAdd"
			case .viewScheduleListHeaderNameUpcomingToday:
					return "viewScheduleListHeaderNameUpcomingToday"
			case .remove:
					return "remove"
			case .exchangeKey:
					return "exchangeKey"
			case .notificationForegroundServiceTextDriverMeetWithCustomer:
					return "notificationForegroundServiceTextDriverMeetWithCustomer"
			case .viewScheduleStateRefreshButton:
					return "viewScheduleStateRefreshButton"
			case .volvoYearModel:
					return "volvoYearModel"
			case .popupSignoutConfirmationMessage:
					return "popupSignoutConfirmationMessage"
			case .viewRetrieveVehicle:
					return "viewRetrieveVehicle"
			case .notificationForegroundServiceTextGetToDealership:
					return "notificationForegroundServiceTextGetToDealership"
			case .errorInvalidApplicationVersion:
					return "errorInvalidApplicationVersion"
			case .notificationForegroundServiceTitle:
					return "notificationForegroundServiceTitle"
			case .viewInspectDocumentsMinPhotoWarning:
					return "viewInspectDocumentsMinPhotoWarning"
			case .number2:
					return "number2"
			case .errorInvalidPhoneNumber:
					return "errorInvalidPhoneNumber"
			case .errorLocationServiceUnavailable:
					return "errorLocationServiceUnavailable"
			case .viewTosContentTermsOfServiceUrl:
					return "viewTosContentTermsOfServiceUrl"
			case .serviceColon:
					return "serviceColon"
			case .viewInspectNotes:
					return "viewInspectNotes"
			case .recentMileageColon:
					return "recentMileageColon"
			case .errorLocationServiceNotOfferedInYourArea:
					return "errorLocationServiceNotOfferedInYourArea"
			case .change:
					return "change"
			case .viewRetrieveFormsInfoNext:
					return "viewRetrieveFormsInfoNext"
			case .errorRequestNotCancelable:
					return "errorRequestNotCancelable"
			case .popupPhoneVerificationResendCodeTitle:
					return "popupPhoneVerificationResendCodeTitle"
			case .notificationForegroundServiceTextRecordLoanerMileage:
					return "notificationForegroundServiceTextRecordLoanerMileage"
			case .viewScheduleListHeaderNameCurrent:
					return "viewScheduleListHeaderNameCurrent"
			case .requestReset:
					return "requestReset"
			case .errorAmbiguousCustomerUpsert:
					return "errorAmbiguousCustomerUpsert"
			case .viewReceiveVehicle:
					return "viewReceiveVehicle"
			case .new:
					return "new"
			case .notificationForegroundServiceTextDriverExchangeKeys:
					return "notificationForegroundServiceTextDriverExchangeKeys"
			case .viewDrivetoCustomer:
					return "viewDrivetoCustomer"
			case .errorInvalidVerificationCode:
					return "errorInvalidVerificationCode"
			case .popupPhoneVerificationResendCodeMessage:
					return "popupPhoneVerificationResendCodeMessage"
			case .number1:
					return "number1"
			case .viewInspectNotesDescriptionHint:
					return "viewInspectNotesDescriptionHint"
			case .year:
					return "year"
			case .updateNow:
					return "updateNow"
			case .errorOnline:
					return "errorOnline"
			case .returnToDealership:
					return "returnToDealership"
			case .number4:
					return "number4"
			case .notificationForegroundServiceTextRetrieveLoaner:
					return "notificationForegroundServiceTextRetrieveLoaner"
			case .notificationBatteryWarningTitle:
					return "notificationBatteryWarningTitle"
			case .viewStartRequestPickup:
					return "viewStartRequestPickup"
			case .viewSigninPasswordShort:
					return "viewSigninPasswordShort"
			case .viewRetrieveVehicleCustomerInfoNext:
					return "viewRetrieveVehicleCustomerInfoNext"
			case .viewReceiveVehicleLoaner:
					return "viewReceiveVehicleLoaner"
			case .edit:
					return "edit"
			case .deliveryColon:
					return "deliveryColon"
			case .viewArrivedatPickupSwipeButtonTitle:
					return "viewArrivedatPickupSwipeButtonTitle"
			case .viewSchedule:
					return "viewSchedule"
			case .errorInvalidUserDisabled:
					return "errorInvalidUserDisabled"
			case .notificationForegroundServiceTextDriveCustomerToDealership:
					return "notificationForegroundServiceTextDriveCustomerToDealership"
			case .viewPhoneVerificationLabel:
					return "viewPhoneVerificationLabel"
			case .unknown:
					return "unknown"
			case .notificationActionOpen:
					return "notificationActionOpen"
			case .errorUserDisabled:
					return "errorUserDisabled"
			case .viewSigninEmailInvalid:
					return "viewSigninEmailInvalid"
			case .support:
					return "support"
			case .viewScheduleStateRefreshInfo:
					return "viewScheduleStateRefreshInfo"
			case .viewRecordLoanerMileagePickupSwipeButtonTitle:
					return "viewRecordLoanerMileagePickupSwipeButtonTitle"
			case .notAvailable:
					return "notAvailable"
			case .viewTosContent:
					return "viewTosContent"
			case .viewEmailBody:
					return "viewEmailBody"
			case .errorInvalidPasswordUnauthorizedCharacters:
					return "errorInvalidPasswordUnauthorizedCharacters"
			case .viewRecordLoanerMileageDropoffInfoNext:
					return "viewRecordLoanerMileageDropoffInfoNext"
			case .errorInvalidPasswordConfirm:
					return "errorInvalidPasswordConfirm"
			case .viewInspectCustomerMinPhotoWarning:
					return "viewInspectCustomerMinPhotoWarning"
			case .next:
					return "next"
			case .popupForgotPasswordTitle:
					return "popupForgotPasswordTitle"
			case .addressColon:
					return "addressColon"
			case .viewDrivetoArriveatCustomer:
					return "viewDrivetoArriveatCustomer"
			case .confirmationCode:
					return "confirmationCode"
			case .viewTosContentTermsOfService:
					return "viewTosContentTermsOfService"
			case .viewChecklistLoanerAgreementLabel:
					return "viewChecklistLoanerAgreementLabel"
			case .viewHelpOptionDetailCallVolvo:
					return "viewHelpOptionDetailCallVolvo"
			case .delivery:
					return "delivery"
			case .viewProfileChangePasswordTemp:
					return "viewProfileChangePasswordTemp"
			case .viewNavigateAddressCopiedToClipboard:
					return "viewNavigateAddressCopiedToClipboard"
			case .popupMileageMaxConfirmation:
					return "popupMileageMaxConfirmation"
			case .notificationBatteryWarningTextBig:
					return "notificationBatteryWarningTextBig"
			case .notificationForegroundServiceTextDriverInspectCustomer:
					return "notificationForegroundServiceTextDriverInspectCustomer"
			case .permissionsLocationDeniedTitle:
					return "permissionsLocationDeniedTitle"
			case .emailAddress:
					return "emailAddress"
			case .popupAddNewLocationLabel:
					return "popupAddNewLocationLabel"
			case .errorRemoveVehicleError:
					return "errorRemoveVehicleError"
			case .viewRecordLoanerMileage:
					return "viewRecordLoanerMileage"
			case .popupGetToCustomerTitle:
					return "popupGetToCustomerTitle"
			case .viewStartRequestRetrieveLoaner:
					return "viewStartRequestRetrieveLoaner"
			case .number3:
					return "number3"
			case .errorOops:
					return "errorOops"
			case .number10:
					return "number10"
			case .viewInspectLoanerMinPhotosWarning:
					return "viewInspectLoanerMinPhotosWarning"
			case .viewRetrieveVehicleLoanerSwipeTitle:
					return "viewRetrieveVehicleLoanerSwipeTitle"
			case .viewScheduleServiceStatusSelfAdvisorDropoff:
					return "viewScheduleServiceStatusSelfAdvisorDropoff"
			case .popupAlreadyStartedDrivingTitle:
					return "popupAlreadyStartedDrivingTitle"
			case .errorVerifyPhoneNumber:
					return "errorVerifyPhoneNumber"
			case .viewIntroFooterSignup:
					return "viewIntroFooterSignup"
			case .popupTooFarFromDealershipPositive:
					return "popupTooFarFromDealershipPositive"
			case .viewTosContentPrivacyPolicyUrl:
					return "viewTosContentPrivacyPolicyUrl"
			case .viewDrivetoSwipeButtonTitle:
					return "viewDrivetoSwipeButtonTitle"
			case .requestTaskChangedFromBackend:
					return "requestTaskChangedFromBackend"
			case .notificationForegroundServiceTextRetrieveForms:
					return "notificationForegroundServiceTextRetrieveForms"
			case .viewGettoDealershipSwipeButtonTitle:
					return "viewGettoDealershipSwipeButtonTitle"
			case .viewProfileChangeContact:
					return "viewProfileChangeContact"
			case .permissionsCameraDeniedTitle:
					return "permissionsCameraDeniedTitle"
			case .viewDrawerNavigationPreferenceGoogle:
					return "viewDrawerNavigationPreferenceGoogle"
			case .viewHelpCategoryLastLeg:
					return "viewHelpCategoryLastLeg"
			case .viewNavigateText:
					return "viewNavigateText"
			case .viewInspectLoaner:
					return "viewInspectLoaner"
			case .toastSettingsLocationDisabled:
					return "toastSettingsLocationDisabled"
			case .currentPassword:
					return "currentPassword"
			case .viewInspectCustomerMinPhotosWarning:
					return "viewInspectCustomerMinPhotosWarning"
        }
    }
    
    var description: String {
        return NSLocalizedString(self.key, tableName: nil, bundle: Localized.Bundles.framework, value: self.key, comment: self.key)
    }
    
    func with(_ args: CVarArg...) -> String {
        let format = description
        return String(format: format, arguments: args)
    }
    
}

extension String {
    static func localized(_ localized: Localized) -> String {
        return localized.description
    }
}
