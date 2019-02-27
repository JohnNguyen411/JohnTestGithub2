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
    
    case viewSigninForgotPassword
	case notificationForegroundServiceTextDriverInspectCustomer
	case viewExchangeKeysSwipeButtonTitle
	case viewScheduleStateRefreshButton
	case helpICantUpdateMyPhone
	case number2
	case loading
	case popupSignoutConfirmationMessage
	case viewPhoneVerificationLabel
	case viewExchangeKeysDeliverySwipeTitle
	case notificationForegroundServiceTextRetrieveLoaner
	case iAmSure
	case permissionsCameraDeniedTitle
	case viewRecordLoanerMileageDropoffInfoNext
	case notificationForegroundServiceTextDriverMeetWithCustomer
	case popupSelectTimeSlotUnavailableCallDealership
	case retry
	case repairOrderColon
	case viewLogoTitle
	case notificationForegroundServiceTextDriveCustomerToDealership
	case popupAlreadyStartedDrivingPositive
	case licensePlateColon
	case errorLocationOutOfDropoffArea
	case viewArrivedatPickupSwipeButtonTitle
	case viewRetrieveVehicleCustomerSwipeTitle
	case number10
	case errorOffline
	case notificationForegroundServiceTextInspectNotes
	case add
	case number8
	case number6
	case viewTosContentTermsOfServiceUrl
	case errorInvalidEmail
	case popupGetToCustomerCopyToClipboard
	case errorIllegalRequestTaskChange
	case loanerColon
	case viewHelpOptionDetailEmailVolvo
	case viewScheduleServiceStatusSelfDealershipNavigate
	case viewScheduleServiceTypeOtherUnknown
	case requestReset
	case inspectVehicle
	case new
	case viewSigninActionSignin
	case createPassword
	case phoneNumber
	case notificationForegroundServiceTextDriverInspectDocuments
	case popupMileageMinConfirmation
	case viewInspectLoanerMinPhotoWarning
	case notificationActionOpen
	case viewReceiveVehicleCustomerSwipeButtonTitle
	case errorInvalidLastName
	case confirmNewPassword
	case currentPassword
	case viewDrawerProfileOptionsAttributions
	case close
	case viewNavigateWazeText
	case errorInvalidPasswordConfirm
	case viewArrivedatDeliveryInspectVehicles
	case popupHardRefreshTitle
	case errorIllegalRequestStateChange
	case edit
	case viewTosContentTermsOfServiceTitle
	case popupTooFarFromDealershipMessage
	case popupTooFarFromCustomerPositive
	case vehicleMake
	case viewScheduleEmpty
	case viewReceiveVehicleCustomer
	case viewScheduleStateRefreshInfo
	case popupHardRefreshMessage
	case number3
	case next
	case viewInspectCustomerMinPhotoWarning
	case requestCanceled
	case viewRetrieveVehicle
	case viewSwipeButtonInnerText
	case viewSigninPhoto
	case viewRetrieveVehicleLoanerSwipeTitle
	case viewReceiveVehicleLoanerSwipeButtonTitle
	case notificationForegroundServiceTextDriverInspectLoaner
	case errorLocationServiceNotOfferedInYourArea
	case mins
	case viewInspectDocumentsOverlayInfo
	case errorOnline
	case viewProfileChangePasswordTemp
	case dealershipAddressColon
	case viewScheduleListHeaderNameUpcomingToday
	case viewRetrieveVehicleCustomerInfoNext
	case errorInvalidApplicationVersion
	case viewTosContentTermsOfService
	case viewInspectLoanerMinPhotosWarning
	case number5
	case exchangeKey
	case viewRecordLoanerMileagePickupSwipeButtonTitle
	case errorSoftUpgradeMessage
	case viewTosContentPrivacyPolicyTitle
	case confirmationCode
	case done
	case notificationForegroundServiceTextDriverGetToCustomer
	case viewSignin
	case viewReturntoSwipeButtonTitle
	case popupDeviceChangeTitle
	case popupAlreadyStartedDrivingTitle
	case viewInspectDocumentsMinPhotoWarning
	case viewArrivedat
	case inspectVehicles
	case viewReceiveVehicleLoanerNext
	case errorLocationServiceUnavailable
	case no
	case requestTaskChangedFromBackend
	case viewDrivetoCustomer
	case errorFaceDetectionMessage
	case viewHelpOptionDetailCallDealer
	case viewIntro
	case phoneNumberAlreadyTaken
	case viewScheduleCurrent
	case updateNow
	case later
	case viewChecklistLoanerAgreementLabel
	case popupGetToDealershipTitle
	case viewPhoneAdd
	case errorInvalidPhoneNumber
	case dismiss
	case viewEmailSubject
	case viewHelpOptionDetailCallVolvo
	case errorInvalidPasswordUnauthorizedCharacters
	case signout
	case errorInvalidFirstName
	case keyCodeColon
	case popupPhoneVerificationResendCodeMessage
	case viewInspectCustomer
	case viewRetrieveFormsInfoNext
	case help
	case viewScheduleServiceStatusSelfFooterTitleDropoff
	case remove
	case notificationForegroundServiceTextRetrieveForms
	case cancel
	case notAvailable
	case viewGetToText
	case appName
	case viewInspectNotesDescriptionHint
	case requestCompleted
	case viewScheduleListHeaderNameCurrent
	case errorInvalidCredentials
	case viewScheduleServiceStatusSelfAdvisorPickup
	case notificationForegroundServiceTextDriverVehicleToCustomer
	case popupDeviceChangeMessage
	case viewInspectLoanerOverlayInfo
	case notificationForegroundServiceTextGetToDealership
	case unknown
	case errorOops
	case model
	case viewIntroFooterSignup
	case viewDrivetoArriveatCustomer
	case notificationForegroundServiceTextReceiveLoaner
	case errorForcedUpgradeTitle
	case notificationBatteryWarningTitle
	case viewSchedule
	case volvoYearModel
	case newPassword
	case viewDrawerProfileOptionsSignout
	case popupChooseDealershipTitle
	case popupMileageMaxConfirmation
	case viewReceiveVehicleInfoReminder
	case serviceColon
	case settings
	case viewStartRequestRetrieveLoaner
	case viewInspectDocumentsMinPhotosWarning
	case popupForgotPasswordTitle
	case viewEmailIntentChooserTitle
	case yourAccount
	case viewScheduleEmptyToday
	case viewDrawerProfileOptionsChangeContact
	case popupUpdatingLocation
	case viewContactText
	case viewStartRequestRetrieveCustomerVehicle
	case modelColon
	case pickupColon
	case permissionsLocationDeniedMessage
	case pickup
	case errorAmbiguousCustomerUpsert
	case viewArrivedatDeliverySwipeButtonTitle
	case notificationForegroundServiceTextDriveLoanerToDealership
	case viewInspectNotes
	case viewHelpCategoryLastLeg
	case errorAmbiguousVehicleUpsert
	case popupForgotPasswordMessage
	case notificationForegroundServiceTextRecordLoanerMileage
	case popupSoftUpgradeNegative
	case viewDrawerNavigationPreferenceTitle
	case permissionsCameraDeniedMessage
	case viewDrawerNavigationPreferenceGoogle
	case viewRetrieveVehicleCustomer
	case viewInspectLoaner
	case viewRetrieveFormsSwipeTitle
	case viewGettoCustomer
	case viewScheduleListItemTypeDeliver
	case openSettings
	case update
	case number7
	case viewTosContentPrivacyPolicyUrl
	case viewDrawerContactDealershipText
	case viewRetrieveVehicleLoaner
	case phoneNumberCannotBeEmpty
	case viewContactCall
	case popupAlreadyStartedDrivingMessage
	case viewStartRequestPickup
	case notificationForegroundServiceTextRetrieveVehicle
	case back
	case errorVerifyPhoneNumber
	case viewDrawerContactDealershipCall
	case viewInspectCustomerMinPhotosWarning
	case min
	case error
	case popupGetToDealershipCopyToClipboard
	case viewIntroFooterSignin
	case errorInvalidPhoneVerificationCode
	case viewStartRequestDropoff
	case notesColon
	case viewInspectCustomerOverlayInfo
	case goBack
	case notificationForegroundServiceTextDriverLoanerToCustomer
	case viewScheduleState
	case viewNavigateAddressCopiedToClipboard
	case skip
	case year
	case addressColon
	case confirmPhoneNumber
	case viewHelpCategoryHowLuxeByVolvoWorks
	case popupGetToCustomerTitle
	case notificationBatteryWarningTextBig
	case exchangeKeys
	case errorPhoneNumberTaken
	case viewTosContentPrivacyPolicy
	case popupPhoneVerificationResendCodeTitle
	case viewScheduleServiceStatusSelfAdvisorDropoff
	case errorInvalidVerificationCode
	case viewRecordLoanerMileage
	case viewDrawerNavigationPreferenceWaze
	case viewReceiveVehicle
	case number4
	case viewStartRequestRetrieveForms
	case errorDuplicateLoanerVehicleBookingAssignment
	case errorLocationOutOfPickupArea
	case dealership
	case viewPhoneAddLabel
	case viewArrivedatCustomer
	case popupTooFarFromCustomerMessage
	case resendCode
	case readMore
	case change
	case permissionsLocationDeniedTitle
	case customerColon
	case deliveryColon
	case viewGettoCustomerArriveatCustomer
	case number9
	case viewScheduleListItemTypePickup
	case recentMileageColon
	case viewExchangeKeysInfoReminder
	case viewSoftwareLicences
	case password
	case returnToDealership
	case toastSettingsLocationDisabled
	case contact
	case passwordRequirements
	case viewHelpCategoryTroubleWithLuxeByVolvoApp
	case viewGettoCustomerSwipeButtonTitle
	case viewGettoDealershipSwipeButtonTitle
	case viewExchangeKeysPickupSwipeTitle
	case errorInvalidUserDisabled
	case delivery
	case viewNavigateText
	case helpIForgotMyPassword
	case viewHelpOptionDetailEmailDealer
	case viewTosContent
	case viewStartRequestSwipeButtonTitle
	case viewEmailBody
	case viewInspectDocuments
	case viewInspectNotesSwipeButtonTitle
	case number11
	case errorInvalidPassword
	case popupTooFarFromDealershipPositive
	case errorEnterLoanerMileage
	case popupTooFarFromDealershipTitle
	case errorUserDisabled
	case errorRequestNotCancelable
	case viewReceiveVehicleLoaner
	case viewSigninEmailInvalid
	case errorForcedUpgradeMessage
	case ok
	case emailAddress
	case viewSigninPasswordShort
	case viewSigninPopupProgressSignin
	case errorUnknown
	case support
	case errorAccountAlreadyExists
	case errorRemoveVehicleError
	case viewDriveto
	case yes
	case viewRetrieveForms
	case viewRecordLoanerMileageDropoffSwipeButtonTitle
	case popupAddNewLocationLabel
	case viewProfileChangeContact
	case errorSoftUpgradeTitle
	case notificationForegroundServiceTextDriverExchangeKeys
	case number1
	case viewDrawerProfileOptionsChangePassword
	case popupTooFarFromCustomerTitle
	case color
	case viewDrivetoSwipeButtonTitle
	case notificationForegroundServiceTitle
	case viewScheduleListHeaderNameCompletedToday
	case notNow
	case notificationBatteryWarningText

    var key : String {
        switch self {
            case .viewSigninForgotPassword:
					return "viewSigninForgotPassword"
			case .notificationForegroundServiceTextDriverInspectCustomer:
					return "notificationForegroundServiceTextDriverInspectCustomer"
			case .viewExchangeKeysSwipeButtonTitle:
					return "viewExchangeKeysSwipeButtonTitle"
			case .viewScheduleStateRefreshButton:
					return "viewScheduleStateRefreshButton"
			case .helpICantUpdateMyPhone:
					return "helpICantUpdateMyPhone"
			case .number2:
					return "number2"
			case .loading:
					return "loading"
			case .popupSignoutConfirmationMessage:
					return "popupSignoutConfirmationMessage"
			case .viewPhoneVerificationLabel:
					return "viewPhoneVerificationLabel"
			case .viewExchangeKeysDeliverySwipeTitle:
					return "viewExchangeKeysDeliverySwipeTitle"
			case .notificationForegroundServiceTextRetrieveLoaner:
					return "notificationForegroundServiceTextRetrieveLoaner"
			case .iAmSure:
					return "iAmSure"
			case .permissionsCameraDeniedTitle:
					return "permissionsCameraDeniedTitle"
			case .viewRecordLoanerMileageDropoffInfoNext:
					return "viewRecordLoanerMileageDropoffInfoNext"
			case .notificationForegroundServiceTextDriverMeetWithCustomer:
					return "notificationForegroundServiceTextDriverMeetWithCustomer"
			case .popupSelectTimeSlotUnavailableCallDealership:
					return "popupSelectTimeSlotUnavailableCallDealership"
			case .retry:
					return "retry"
			case .repairOrderColon:
					return "repairOrderColon"
			case .viewLogoTitle:
					return "viewLogoTitle"
			case .notificationForegroundServiceTextDriveCustomerToDealership:
					return "notificationForegroundServiceTextDriveCustomerToDealership"
			case .popupAlreadyStartedDrivingPositive:
					return "popupAlreadyStartedDrivingPositive"
			case .licensePlateColon:
					return "licensePlateColon"
			case .errorLocationOutOfDropoffArea:
					return "errorLocationOutOfDropoffArea"
			case .viewArrivedatPickupSwipeButtonTitle:
					return "viewArrivedatPickupSwipeButtonTitle"
			case .viewRetrieveVehicleCustomerSwipeTitle:
					return "viewRetrieveVehicleCustomerSwipeTitle"
			case .number10:
					return "number10"
			case .errorOffline:
					return "errorOffline"
			case .notificationForegroundServiceTextInspectNotes:
					return "notificationForegroundServiceTextInspectNotes"
			case .add:
					return "add"
			case .number8:
					return "number8"
			case .number6:
					return "number6"
			case .viewTosContentTermsOfServiceUrl:
					return "viewTosContentTermsOfServiceUrl"
			case .errorInvalidEmail:
					return "errorInvalidEmail"
			case .popupGetToCustomerCopyToClipboard:
					return "popupGetToCustomerCopyToClipboard"
			case .errorIllegalRequestTaskChange:
					return "errorIllegalRequestTaskChange"
			case .loanerColon:
					return "loanerColon"
			case .viewHelpOptionDetailEmailVolvo:
					return "viewHelpOptionDetailEmailVolvo"
			case .viewScheduleServiceStatusSelfDealershipNavigate:
					return "viewScheduleServiceStatusSelfDealershipNavigate"
			case .viewScheduleServiceTypeOtherUnknown:
					return "viewScheduleServiceTypeOtherUnknown"
			case .requestReset:
					return "requestReset"
			case .inspectVehicle:
					return "inspectVehicle"
			case .new:
					return "new"
			case .viewSigninActionSignin:
					return "viewSigninActionSignin"
			case .createPassword:
					return "createPassword"
			case .phoneNumber:
					return "phoneNumber"
			case .notificationForegroundServiceTextDriverInspectDocuments:
					return "notificationForegroundServiceTextDriverInspectDocuments"
			case .popupMileageMinConfirmation:
					return "popupMileageMinConfirmation"
			case .viewInspectLoanerMinPhotoWarning:
					return "viewInspectLoanerMinPhotoWarning"
			case .notificationActionOpen:
					return "notificationActionOpen"
			case .viewReceiveVehicleCustomerSwipeButtonTitle:
					return "viewReceiveVehicleCustomerSwipeButtonTitle"
			case .errorInvalidLastName:
					return "errorInvalidLastName"
			case .confirmNewPassword:
					return "confirmNewPassword"
			case .currentPassword:
					return "currentPassword"
			case .viewDrawerProfileOptionsAttributions:
					return "viewDrawerProfileOptionsAttributions"
			case .close:
					return "close"
			case .viewNavigateWazeText:
					return "viewNavigateWazeText"
			case .errorInvalidPasswordConfirm:
					return "errorInvalidPasswordConfirm"
			case .viewArrivedatDeliveryInspectVehicles:
					return "viewArrivedatDeliveryInspectVehicles"
			case .popupHardRefreshTitle:
					return "popupHardRefreshTitle"
			case .errorIllegalRequestStateChange:
					return "errorIllegalRequestStateChange"
			case .edit:
					return "edit"
			case .viewTosContentTermsOfServiceTitle:
					return "viewTosContentTermsOfServiceTitle"
			case .popupTooFarFromDealershipMessage:
					return "popupTooFarFromDealershipMessage"
			case .popupTooFarFromCustomerPositive:
					return "popupTooFarFromCustomerPositive"
			case .vehicleMake:
					return "vehicleMake"
			case .viewScheduleEmpty:
					return "viewScheduleEmpty"
			case .viewReceiveVehicleCustomer:
					return "viewReceiveVehicleCustomer"
			case .viewScheduleStateRefreshInfo:
					return "viewScheduleStateRefreshInfo"
			case .popupHardRefreshMessage:
					return "popupHardRefreshMessage"
			case .number3:
					return "number3"
			case .next:
					return "next"
			case .viewInspectCustomerMinPhotoWarning:
					return "viewInspectCustomerMinPhotoWarning"
			case .requestCanceled:
					return "requestCanceled"
			case .viewRetrieveVehicle:
					return "viewRetrieveVehicle"
			case .viewSwipeButtonInnerText:
					return "viewSwipeButtonInnerText"
			case .viewSigninPhoto:
					return "viewSigninPhoto"
			case .viewRetrieveVehicleLoanerSwipeTitle:
					return "viewRetrieveVehicleLoanerSwipeTitle"
			case .viewReceiveVehicleLoanerSwipeButtonTitle:
					return "viewReceiveVehicleLoanerSwipeButtonTitle"
			case .notificationForegroundServiceTextDriverInspectLoaner:
					return "notificationForegroundServiceTextDriverInspectLoaner"
			case .errorLocationServiceNotOfferedInYourArea:
					return "errorLocationServiceNotOfferedInYourArea"
			case .mins:
					return "mins"
			case .viewInspectDocumentsOverlayInfo:
					return "viewInspectDocumentsOverlayInfo"
			case .errorOnline:
					return "errorOnline"
			case .viewProfileChangePasswordTemp:
					return "viewProfileChangePasswordTemp"
			case .dealershipAddressColon:
					return "dealershipAddressColon"
			case .viewScheduleListHeaderNameUpcomingToday:
					return "viewScheduleListHeaderNameUpcomingToday"
			case .viewRetrieveVehicleCustomerInfoNext:
					return "viewRetrieveVehicleCustomerInfoNext"
			case .errorInvalidApplicationVersion:
					return "errorInvalidApplicationVersion"
			case .viewTosContentTermsOfService:
					return "viewTosContentTermsOfService"
			case .viewInspectLoanerMinPhotosWarning:
					return "viewInspectLoanerMinPhotosWarning"
			case .number5:
					return "number5"
			case .exchangeKey:
					return "exchangeKey"
			case .viewRecordLoanerMileagePickupSwipeButtonTitle:
					return "viewRecordLoanerMileagePickupSwipeButtonTitle"
			case .errorSoftUpgradeMessage:
					return "errorSoftUpgradeMessage"
			case .viewTosContentPrivacyPolicyTitle:
					return "viewTosContentPrivacyPolicyTitle"
			case .confirmationCode:
					return "confirmationCode"
			case .done:
					return "done"
			case .notificationForegroundServiceTextDriverGetToCustomer:
					return "notificationForegroundServiceTextDriverGetToCustomer"
			case .viewSignin:
					return "viewSignin"
			case .viewReturntoSwipeButtonTitle:
					return "viewReturntoSwipeButtonTitle"
			case .popupDeviceChangeTitle:
					return "popupDeviceChangeTitle"
			case .popupAlreadyStartedDrivingTitle:
					return "popupAlreadyStartedDrivingTitle"
			case .viewInspectDocumentsMinPhotoWarning:
					return "viewInspectDocumentsMinPhotoWarning"
			case .viewArrivedat:
					return "viewArrivedat"
			case .inspectVehicles:
					return "inspectVehicles"
			case .viewReceiveVehicleLoanerNext:
					return "viewReceiveVehicleLoanerNext"
			case .errorLocationServiceUnavailable:
					return "errorLocationServiceUnavailable"
			case .no:
					return "no"
			case .requestTaskChangedFromBackend:
					return "requestTaskChangedFromBackend"
			case .viewDrivetoCustomer:
					return "viewDrivetoCustomer"
			case .errorFaceDetectionMessage:
					return "errorFaceDetectionMessage"
			case .viewHelpOptionDetailCallDealer:
					return "viewHelpOptionDetailCallDealer"
			case .viewIntro:
					return "viewIntro"
			case .phoneNumberAlreadyTaken:
					return "phoneNumberAlreadyTaken"
			case .viewScheduleCurrent:
					return "viewScheduleCurrent"
			case .updateNow:
					return "updateNow"
			case .later:
					return "later"
			case .viewChecklistLoanerAgreementLabel:
					return "viewChecklistLoanerAgreementLabel"
			case .popupGetToDealershipTitle:
					return "popupGetToDealershipTitle"
			case .viewPhoneAdd:
					return "viewPhoneAdd"
			case .errorInvalidPhoneNumber:
					return "errorInvalidPhoneNumber"
			case .dismiss:
					return "dismiss"
			case .viewEmailSubject:
					return "viewEmailSubject"
			case .viewHelpOptionDetailCallVolvo:
					return "viewHelpOptionDetailCallVolvo"
			case .errorInvalidPasswordUnauthorizedCharacters:
					return "errorInvalidPasswordUnauthorizedCharacters"
			case .signout:
					return "signout"
			case .errorInvalidFirstName:
					return "errorInvalidFirstName"
			case .keyCodeColon:
					return "keyCodeColon"
			case .popupPhoneVerificationResendCodeMessage:
					return "popupPhoneVerificationResendCodeMessage"
			case .viewInspectCustomer:
					return "viewInspectCustomer"
			case .viewRetrieveFormsInfoNext:
					return "viewRetrieveFormsInfoNext"
			case .help:
					return "help"
			case .viewScheduleServiceStatusSelfFooterTitleDropoff:
					return "viewScheduleServiceStatusSelfFooterTitleDropoff"
			case .remove:
					return "remove"
			case .notificationForegroundServiceTextRetrieveForms:
					return "notificationForegroundServiceTextRetrieveForms"
			case .cancel:
					return "cancel"
			case .notAvailable:
					return "notAvailable"
			case .viewGetToText:
					return "viewGetToText"
			case .appName:
					return "appName"
			case .viewInspectNotesDescriptionHint:
					return "viewInspectNotesDescriptionHint"
			case .requestCompleted:
					return "requestCompleted"
			case .viewScheduleListHeaderNameCurrent:
					return "viewScheduleListHeaderNameCurrent"
			case .errorInvalidCredentials:
					return "errorInvalidCredentials"
			case .viewScheduleServiceStatusSelfAdvisorPickup:
					return "viewScheduleServiceStatusSelfAdvisorPickup"
			case .notificationForegroundServiceTextDriverVehicleToCustomer:
					return "notificationForegroundServiceTextDriverVehicleToCustomer"
			case .popupDeviceChangeMessage:
					return "popupDeviceChangeMessage"
			case .viewInspectLoanerOverlayInfo:
					return "viewInspectLoanerOverlayInfo"
			case .notificationForegroundServiceTextGetToDealership:
					return "notificationForegroundServiceTextGetToDealership"
			case .unknown:
					return "unknown"
			case .errorOops:
					return "errorOops"
			case .model:
					return "model"
			case .viewIntroFooterSignup:
					return "viewIntroFooterSignup"
			case .viewDrivetoArriveatCustomer:
					return "viewDrivetoArriveatCustomer"
			case .notificationForegroundServiceTextReceiveLoaner:
					return "notificationForegroundServiceTextReceiveLoaner"
			case .errorForcedUpgradeTitle:
					return "errorForcedUpgradeTitle"
			case .notificationBatteryWarningTitle:
					return "notificationBatteryWarningTitle"
			case .viewSchedule:
					return "viewSchedule"
			case .volvoYearModel:
					return "volvoYearModel"
			case .newPassword:
					return "newPassword"
			case .viewDrawerProfileOptionsSignout:
					return "viewDrawerProfileOptionsSignout"
			case .popupChooseDealershipTitle:
					return "popupChooseDealershipTitle"
			case .popupMileageMaxConfirmation:
					return "popupMileageMaxConfirmation"
			case .viewReceiveVehicleInfoReminder:
					return "viewReceiveVehicleInfoReminder"
			case .serviceColon:
					return "serviceColon"
			case .settings:
					return "settings"
			case .viewStartRequestRetrieveLoaner:
					return "viewStartRequestRetrieveLoaner"
			case .viewInspectDocumentsMinPhotosWarning:
					return "viewInspectDocumentsMinPhotosWarning"
			case .popupForgotPasswordTitle:
					return "popupForgotPasswordTitle"
			case .viewEmailIntentChooserTitle:
					return "viewEmailIntentChooserTitle"
			case .yourAccount:
					return "yourAccount"
			case .viewScheduleEmptyToday:
					return "viewScheduleEmptyToday"
			case .viewDrawerProfileOptionsChangeContact:
					return "viewDrawerProfileOptionsChangeContact"
			case .popupUpdatingLocation:
					return "popupUpdatingLocation"
			case .viewContactText:
					return "viewContactText"
			case .viewStartRequestRetrieveCustomerVehicle:
					return "viewStartRequestRetrieveCustomerVehicle"
			case .modelColon:
					return "modelColon"
			case .pickupColon:
					return "pickupColon"
			case .permissionsLocationDeniedMessage:
					return "permissionsLocationDeniedMessage"
			case .pickup:
					return "pickup"
			case .errorAmbiguousCustomerUpsert:
					return "errorAmbiguousCustomerUpsert"
			case .viewArrivedatDeliverySwipeButtonTitle:
					return "viewArrivedatDeliverySwipeButtonTitle"
			case .notificationForegroundServiceTextDriveLoanerToDealership:
					return "notificationForegroundServiceTextDriveLoanerToDealership"
			case .viewInspectNotes:
					return "viewInspectNotes"
			case .viewHelpCategoryLastLeg:
					return "viewHelpCategoryLastLeg"
			case .errorAmbiguousVehicleUpsert:
					return "errorAmbiguousVehicleUpsert"
			case .popupForgotPasswordMessage:
					return "popupForgotPasswordMessage"
			case .notificationForegroundServiceTextRecordLoanerMileage:
					return "notificationForegroundServiceTextRecordLoanerMileage"
			case .popupSoftUpgradeNegative:
					return "popupSoftUpgradeNegative"
			case .viewDrawerNavigationPreferenceTitle:
					return "viewDrawerNavigationPreferenceTitle"
			case .permissionsCameraDeniedMessage:
					return "permissionsCameraDeniedMessage"
			case .viewDrawerNavigationPreferenceGoogle:
					return "viewDrawerNavigationPreferenceGoogle"
			case .viewRetrieveVehicleCustomer:
					return "viewRetrieveVehicleCustomer"
			case .viewInspectLoaner:
					return "viewInspectLoaner"
			case .viewRetrieveFormsSwipeTitle:
					return "viewRetrieveFormsSwipeTitle"
			case .viewGettoCustomer:
					return "viewGettoCustomer"
			case .viewScheduleListItemTypeDeliver:
					return "viewScheduleListItemTypeDeliver"
			case .openSettings:
					return "openSettings"
			case .update:
					return "update"
			case .number7:
					return "number7"
			case .viewTosContentPrivacyPolicyUrl:
					return "viewTosContentPrivacyPolicyUrl"
			case .viewDrawerContactDealershipText:
					return "viewDrawerContactDealershipText"
			case .viewRetrieveVehicleLoaner:
					return "viewRetrieveVehicleLoaner"
			case .phoneNumberCannotBeEmpty:
					return "phoneNumberCannotBeEmpty"
			case .viewContactCall:
					return "viewContactCall"
			case .popupAlreadyStartedDrivingMessage:
					return "popupAlreadyStartedDrivingMessage"
			case .viewStartRequestPickup:
					return "viewStartRequestPickup"
			case .notificationForegroundServiceTextRetrieveVehicle:
					return "notificationForegroundServiceTextRetrieveVehicle"
			case .back:
					return "back"
			case .errorVerifyPhoneNumber:
					return "errorVerifyPhoneNumber"
			case .viewDrawerContactDealershipCall:
					return "viewDrawerContactDealershipCall"
			case .viewInspectCustomerMinPhotosWarning:
					return "viewInspectCustomerMinPhotosWarning"
			case .min:
					return "min"
			case .error:
					return "error"
			case .popupGetToDealershipCopyToClipboard:
					return "popupGetToDealershipCopyToClipboard"
			case .viewIntroFooterSignin:
					return "viewIntroFooterSignin"
			case .errorInvalidPhoneVerificationCode:
					return "errorInvalidPhoneVerificationCode"
			case .viewStartRequestDropoff:
					return "viewStartRequestDropoff"
			case .notesColon:
					return "notesColon"
			case .viewInspectCustomerOverlayInfo:
					return "viewInspectCustomerOverlayInfo"
			case .goBack:
					return "goBack"
			case .notificationForegroundServiceTextDriverLoanerToCustomer:
					return "notificationForegroundServiceTextDriverLoanerToCustomer"
			case .viewScheduleState:
					return "viewScheduleState"
			case .viewNavigateAddressCopiedToClipboard:
					return "viewNavigateAddressCopiedToClipboard"
			case .skip:
					return "skip"
			case .year:
					return "year"
			case .addressColon:
					return "addressColon"
			case .confirmPhoneNumber:
					return "confirmPhoneNumber"
			case .viewHelpCategoryHowLuxeByVolvoWorks:
					return "viewHelpCategoryHowLuxeByVolvoWorks"
			case .popupGetToCustomerTitle:
					return "popupGetToCustomerTitle"
			case .notificationBatteryWarningTextBig:
					return "notificationBatteryWarningTextBig"
			case .exchangeKeys:
					return "exchangeKeys"
			case .errorPhoneNumberTaken:
					return "errorPhoneNumberTaken"
			case .viewTosContentPrivacyPolicy:
					return "viewTosContentPrivacyPolicy"
			case .popupPhoneVerificationResendCodeTitle:
					return "popupPhoneVerificationResendCodeTitle"
			case .viewScheduleServiceStatusSelfAdvisorDropoff:
					return "viewScheduleServiceStatusSelfAdvisorDropoff"
			case .errorInvalidVerificationCode:
					return "errorInvalidVerificationCode"
			case .viewRecordLoanerMileage:
					return "viewRecordLoanerMileage"
			case .viewDrawerNavigationPreferenceWaze:
					return "viewDrawerNavigationPreferenceWaze"
			case .viewReceiveVehicle:
					return "viewReceiveVehicle"
			case .number4:
					return "number4"
			case .viewStartRequestRetrieveForms:
					return "viewStartRequestRetrieveForms"
			case .errorDuplicateLoanerVehicleBookingAssignment:
					return "errorDuplicateLoanerVehicleBookingAssignment"
			case .errorLocationOutOfPickupArea:
					return "errorLocationOutOfPickupArea"
			case .dealership:
					return "dealership"
			case .viewPhoneAddLabel:
					return "viewPhoneAddLabel"
			case .viewArrivedatCustomer:
					return "viewArrivedatCustomer"
			case .popupTooFarFromCustomerMessage:
					return "popupTooFarFromCustomerMessage"
			case .resendCode:
					return "resendCode"
			case .readMore:
					return "readMore"
			case .change:
					return "change"
			case .permissionsLocationDeniedTitle:
					return "permissionsLocationDeniedTitle"
			case .customerColon:
					return "customerColon"
			case .deliveryColon:
					return "deliveryColon"
			case .viewGettoCustomerArriveatCustomer:
					return "viewGettoCustomerArriveatCustomer"
			case .number9:
					return "number9"
			case .viewScheduleListItemTypePickup:
					return "viewScheduleListItemTypePickup"
			case .recentMileageColon:
					return "recentMileageColon"
			case .viewExchangeKeysInfoReminder:
					return "viewExchangeKeysInfoReminder"
			case .viewSoftwareLicences:
					return "viewSoftwareLicences"
			case .password:
					return "password"
			case .returnToDealership:
					return "returnToDealership"
			case .toastSettingsLocationDisabled:
					return "toastSettingsLocationDisabled"
			case .contact:
					return "contact"
			case .passwordRequirements:
					return "passwordRequirements"
			case .viewHelpCategoryTroubleWithLuxeByVolvoApp:
					return "viewHelpCategoryTroubleWithLuxeByVolvoApp"
			case .viewGettoCustomerSwipeButtonTitle:
					return "viewGettoCustomerSwipeButtonTitle"
			case .viewGettoDealershipSwipeButtonTitle:
					return "viewGettoDealershipSwipeButtonTitle"
			case .viewExchangeKeysPickupSwipeTitle:
					return "viewExchangeKeysPickupSwipeTitle"
			case .errorInvalidUserDisabled:
					return "errorInvalidUserDisabled"
			case .delivery:
					return "delivery"
			case .viewNavigateText:
					return "viewNavigateText"
			case .helpIForgotMyPassword:
					return "helpIForgotMyPassword"
			case .viewHelpOptionDetailEmailDealer:
					return "viewHelpOptionDetailEmailDealer"
			case .viewTosContent:
					return "viewTosContent"
			case .viewStartRequestSwipeButtonTitle:
					return "viewStartRequestSwipeButtonTitle"
			case .viewEmailBody:
					return "viewEmailBody"
			case .viewInspectDocuments:
					return "viewInspectDocuments"
			case .viewInspectNotesSwipeButtonTitle:
					return "viewInspectNotesSwipeButtonTitle"
			case .number11:
					return "number11"
			case .errorInvalidPassword:
					return "errorInvalidPassword"
			case .popupTooFarFromDealershipPositive:
					return "popupTooFarFromDealershipPositive"
			case .errorEnterLoanerMileage:
					return "errorEnterLoanerMileage"
			case .popupTooFarFromDealershipTitle:
					return "popupTooFarFromDealershipTitle"
			case .errorUserDisabled:
					return "errorUserDisabled"
			case .errorRequestNotCancelable:
					return "errorRequestNotCancelable"
			case .viewReceiveVehicleLoaner:
					return "viewReceiveVehicleLoaner"
			case .viewSigninEmailInvalid:
					return "viewSigninEmailInvalid"
			case .errorForcedUpgradeMessage:
					return "errorForcedUpgradeMessage"
			case .ok:
					return "ok"
			case .emailAddress:
					return "emailAddress"
			case .viewSigninPasswordShort:
					return "viewSigninPasswordShort"
			case .viewSigninPopupProgressSignin:
					return "viewSigninPopupProgressSignin"
			case .errorUnknown:
					return "errorUnknown"
			case .support:
					return "support"
			case .errorAccountAlreadyExists:
					return "errorAccountAlreadyExists"
			case .errorRemoveVehicleError:
					return "errorRemoveVehicleError"
			case .viewDriveto:
					return "viewDriveto"
			case .yes:
					return "yes"
			case .viewRetrieveForms:
					return "viewRetrieveForms"
			case .viewRecordLoanerMileageDropoffSwipeButtonTitle:
					return "viewRecordLoanerMileageDropoffSwipeButtonTitle"
			case .popupAddNewLocationLabel:
					return "popupAddNewLocationLabel"
			case .viewProfileChangeContact:
					return "viewProfileChangeContact"
			case .errorSoftUpgradeTitle:
					return "errorSoftUpgradeTitle"
			case .notificationForegroundServiceTextDriverExchangeKeys:
					return "notificationForegroundServiceTextDriverExchangeKeys"
			case .number1:
					return "number1"
			case .viewDrawerProfileOptionsChangePassword:
					return "viewDrawerProfileOptionsChangePassword"
			case .popupTooFarFromCustomerTitle:
					return "popupTooFarFromCustomerTitle"
			case .color:
					return "color"
			case .viewDrivetoSwipeButtonTitle:
					return "viewDrivetoSwipeButtonTitle"
			case .notificationForegroundServiceTitle:
					return "notificationForegroundServiceTitle"
			case .viewScheduleListHeaderNameCompletedToday:
					return "viewScheduleListHeaderNameCompletedToday"
			case .notNow:
					return "notNow"
			case .notificationBatteryWarningText:
					return "notificationBatteryWarningText"
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
