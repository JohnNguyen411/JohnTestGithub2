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
    
    case confirmationCode
	case viewInspectDocuments
	case iAmSure
	case errorLocationServiceNotOfferedInYourArea
	case popupDeviceChangeMessage
	case viewRetrieveVehicleLoaner
	case popupHardRefreshTitle
	case notificationForegroundServiceTextDriverLoanerToCustomer
	case errorOffline
	case viewIntroFooterSignin
	case readMore
	case viewScheduleServiceTypeOtherUnknown
	case popupUpdatingLocation
	case viewReceiveVehicleCustomer
	case notificationForegroundServiceTextGetToDealership
	case skip
	case requestTaskChangedFromBackend
	case errorForcedUpgradeTitle
	case loanerColon
	case viewHelpOptionDetailEmailVolvo
	case number1
	case ok
	case viewInspectCustomerMinPhotosWarning
	case popupAlreadyStartedDrivingPositive
	case notificationForegroundServiceTextRetrieveVehicle
	case popupGetToCustomerCopyToClipboard
	case popupPhoneVerificationResendCodeMessage
	case requestCompleted
	case viewSwipeButtonInnerText
	case viewScheduleEmpty
	case settings
	case viewInspectCustomerOverlayInfo
	case viewStartRequestPickup
	case permissionsLocationDeniedMessage
	case number5
	case viewInspectDocumentsOverlayInfo
	case popupAddNewLocationLabel
	case viewInspectNotesDescriptionHint
	case errorIllegalRequestStateChange
	case error
	case viewDrivetoArriveatCustomer
	case errorVerifyPhoneNumber
	case errorLocationOutOfDropoffArea
	case number7
	case errorInvalidCredentials
	case viewDrivetoCustomer
	case errorRemoveVehicleError
	case errorIllegalRequestTaskChange
	case requestReset
	case vehicleMake
	case popupGetToDealershipCopyToClipboard
	case viewContactText
	case viewProfileChangeContact
	case errorAmbiguousCustomerUpsert
	case dismiss
	case viewExchangeKeysPickupSwipeTitle
	case errorUnknown
	case viewGettoDealershipSwipeButtonTitle
	case notificationForegroundServiceTextDriverMeetWithCustomer
	case viewDrawerProfileOptionsChangePassword
	case viewRetrieveFormsInfoNext
	case signout
	case phoneNumberAlreadyTaken
	case no
	case errorInvalidLastName
	case viewReceiveVehicleLoanerNext
	case support
	case inspectVehicle
	case viewDrawerNavigationPreferenceGoogle
	case viewReceiveVehicle
	case viewScheduleListHeaderNameUpcomingToday
	case number11
	case viewReceiveVehicleLoanerSwipeButtonTitle
	case notificationForegroundServiceTextRetrieveLoaner
	case retry
	case number2
	case viewSchedule
	case viewExchangeKeysSwipeButtonTitle
	case viewHelpCategoryLastLeg
	case licensePlateColon
	case openSettings
	case yourAccount
	case unknown
	case viewStartRequestRetrieveForms
	case notificationActionOpen
	case viewInspectNotesSwipeButtonTitle
	case errorPasswordNotMatch
	case viewEmailSubject
	case popupMileageMaxConfirmation
	case serviceColon
	case notificationForegroundServiceTextDriveCustomerToDealership
	case errorInvalidUserDisabled
	case viewScheduleServiceStatusSelfAdvisorPickup
	case errorOops
	case viewScheduleListHeaderNameCurrent
	case viewSigninPhoto
	case viewDrawerNavigationPreferenceTitle
	case viewExchangeKeysDeliverySwipeTitle
	case errorInvalidPasswordUnauthorizedCharacters
	case yes
	case popupTooFarFromDealershipTitle
	case viewRecordLoanerMileagePickupSwipeButtonTitle
	case inspectVehicles
	case viewScheduleEmptyToday
	case viewInspectDocumentsMinPhotoWarning
	case model
	case viewNavigateAddressCopiedToClipboard
	case viewTosContent
	case viewScheduleServiceStatusSelfFooterTitleDropoff
	case viewDrivetoSwipeButtonTitle
	case errorSoftUpgradeMessage
	case errorInvalidPassword
	case errorPhoneNumberTaken
	case viewInspectLoanerMinPhotoWarning
	case popupTooFarFromCustomerPositive
	case number9
	case viewReceiveVehicleCustomerSwipeButtonTitle
	case notificationForegroundServiceTextDriveLoanerToDealership
	case viewTosContentPrivacyPolicy
	case viewArrivedatDeliverySwipeButtonTitle
	case viewInspectLoanerMinPhotosWarning
	case contact
	case min
	case viewStartRequestDropoff
	case viewScheduleServiceStatusSelfAdvisorDropoff
	case emailAddress
	case number4
	case errorUserDisabled
	case update
	case viewSignupPasswordRequireNumber
	case viewSignin
	case change
	case viewRetrieveVehicleLoanerSwipeTitle
	case notificationBatteryWarningTitle
	case viewDrawerProfileOptionsChangeContact
	case viewSigninEmailInvalid
	case viewHelpCategoryTroubleWithLuxeByVolvoApp
	case notificationForegroundServiceTextDriverInspectLoaner
	case popupGetToCustomerTitle
	case exchangeKeys
	case viewReceiveVehicleLoaner
	case errorInvalidApplicationVersion
	case viewStartRequestRetrieveCustomerVehicle
	case viewSignupPasswordRequireLetter
	case viewDrawerProfileOptionsSignout
	case viewSoftwareLicences
	case errorInvalidPhoneNumber
	case viewHelpOptionDetailCallDealer
	case popupAlreadyStartedDrivingMessage
	case requestCanceled
	case viewDrawerProfileOptionsAttributions
	case viewSigninPasswordShort
	case viewLogoTitle
	case viewTosContentPrivacyPolicyTitle
	case number8
	case viewScheduleStateRefreshButton
	case viewEmailIntentChooserTitle
	case viewReceiveVehicleInfoReminder
	case viewRecordLoanerMileageDropoffInfoNext
	case edit
	case viewDriveto
	case viewTosContentPrivacyPolicyUrl
	case cancel
	case popupSignoutConfirmationMessage
	case done
	case viewGettoCustomerArriveatCustomer
	case viewSigninPopupProgressSignin
	case pickupColon
	case viewInspectLoanerOverlayInfo
	case viewScheduleStateRefreshInfo
	case errorLocationServiceUnavailable
	case errorInvalidPhoneVerificationCode
	case viewInspectDocumentsMinPhotosWarning
	case recentMileageColon
	case viewRecordLoanerMileage
	case appName
	case popupGetToDealershipTitle
	case errorInvalidFirstName
	case popupTooFarFromCustomerTitle
	case viewProfileChangePasswordTemp
	case color
	case newPassword
	case goBack
	case notificationForegroundServiceTextRetrieveForms
	case exchangeKey
	case viewExchangeKeysInfoReminder
	case viewTosContentTermsOfServiceUrl
	case number10
	case viewStartRequestRetrieveLoaner
	case viewScheduleState
	case popupDeviceChangeTitle
	case errorFaceDetectionMessage
	case notesColon
	case viewRetrieveForms
	case viewTosContentTermsOfServiceTitle
	case viewRetrieveVehicleCustomerSwipeTitle
	case viewNavigateWazeText
	case errorOnline
	case remove
	case pickup
	case viewIntro
	case volvoYearModel
	case permissionsCameraDeniedMessage
	case viewContactCall
	case errorRequestNotCancelable
	case currentPassword
	case viewDrawerNavigationPreferenceWaze
	case viewGetToText
	case errorDuplicateLoanerVehicleBookingAssignment
	case viewSigninForgotPassword
	case popupSoftUpgradeNegative
	case popupPhoneVerificationResendCodeTitle
	case viewInspectNotes
	case viewScheduleListHeaderNameCompletedToday
	case notificationBatteryWarningText
	case toastSettingsLocationDisabled
	case repairOrderColon
	case notificationForegroundServiceTextDriverGetToCustomer
	case helpICantUpdateMyPhone
	case viewGettoCustomerSwipeButtonTitle
	case viewHelpOptionDetailEmailDealer
	case viewScheduleListItemTypeDeliver
	case viewRetrieveVehicleCustomer
	case dealershipAddressColon
	case viewArrivedatPickupSwipeButtonTitle
	case viewPhoneAddLabel
	case viewScheduleCurrent
	case viewIntroFooterSignup
	case back
	case createPassword
	case permissionsCameraDeniedTitle
	case viewEmailBody
	case notificationForegroundServiceTextInspectNotes
	case errorSoftUpgradeTitle
	case notificationForegroundServiceTextDriverInspectCustomer
	case errorEnterLoanerMileage
	case notificationForegroundServiceTextDriverVehicleToCustomer
	case viewArrivedatCustomer
	case viewHelpOptionDetailCallVolvo
	case modelColon
	case notificationForegroundServiceTextDriverExchangeKeys
	case errorLocationOutOfPickupArea
	case password
	case add
	case viewReturntoSwipeButtonTitle
	case notNow
	case loading
	case notificationForegroundServiceTextReceiveLoaner
	case delivery
	case viewArrivedat
	case addressColon
	case new
	case viewRetrieveVehicleCustomerInfoNext
	case number3
	case errorInvalidCharacter
	case viewStartRequestSwipeButtonTitle
	case later
	case popupTooFarFromCustomerMessage
	case popupForgotPasswordTitle
	case updateNow
	case deliveryColon
	case errorInvalidPasswordConfirm
	case popupSelectTimeSlotUnavailableCallDealership
	case returnToDealership
	case phoneNumber
	case next
	case errorDatabase
	case viewInspectCustomer
	case errorAccountAlreadyExists
	case confirmNewPassword
	case permissionsLocationDeniedTitle
	case notificationForegroundServiceTextRecordLoanerMileage
	case viewHelpCategoryHowLuxeByVolvoWorks
	case notificationForegroundServiceTitle
	case number6
	case viewGettoCustomer
	case errorSynchingRequest
	case popupHardRefreshMessage
	case popupAlreadyStartedDrivingTitle
	case passwordRequirements
	case popupMileageMinConfirmation
	case viewPhoneAdd
	case viewScheduleListItemTypePickup
	case viewDrawerContactDealershipCall
	case errorInvalidVerificationCode
	case confirmPhoneNumber
	case help
	case phoneNumberCannotBeEmpty
	case errorAmbiguousVehicleUpsert
	case viewPhoneVerificationLabel
	case notificationBatteryWarningTextBig
	case viewInspectCustomerMinPhotoWarning
	case popupChooseDealershipTitle
	case viewRetrieveFormsSwipeTitle
	case errorForcedUpgradeMessage
	case viewDrawerContactDealershipText
	case viewInspectLoaner
	case customerColon
	case dealership
	case notificationForegroundServiceTextDriverInspectDocuments
	case viewSigninActionSignin
	case viewNavigateText
	case mins
	case close
	case viewRecordLoanerMileageDropoffSwipeButtonTitle
	case viewTosContentTermsOfService
	case viewArrivedatDeliveryInspectVehicles
	case viewScheduleServiceStatusSelfDealershipNavigate
	case keyCodeColon
	case popupTooFarFromDealershipPositive
	case popupTooFarFromDealershipMessage
	case errorInvalidEmail
	case viewRetrieveVehicle
	case popupForgotPasswordMessage
	case resendCode
	case helpIForgotMyPassword
	case notAvailable
	case year
	case viewChecklistLoanerAgreementLabel

    var key : String {
        switch self {
            case .confirmationCode:
					return "confirmationCode"
			case .viewInspectDocuments:
					return "viewInspectDocuments"
			case .iAmSure:
					return "iAmSure"
			case .errorLocationServiceNotOfferedInYourArea:
					return "errorLocationServiceNotOfferedInYourArea"
			case .popupDeviceChangeMessage:
					return "popupDeviceChangeMessage"
			case .viewRetrieveVehicleLoaner:
					return "viewRetrieveVehicleLoaner"
			case .popupHardRefreshTitle:
					return "popupHardRefreshTitle"
			case .notificationForegroundServiceTextDriverLoanerToCustomer:
					return "notificationForegroundServiceTextDriverLoanerToCustomer"
			case .errorOffline:
					return "errorOffline"
			case .viewIntroFooterSignin:
					return "viewIntroFooterSignin"
			case .readMore:
					return "readMore"
			case .viewScheduleServiceTypeOtherUnknown:
					return "viewScheduleServiceTypeOtherUnknown"
			case .popupUpdatingLocation:
					return "popupUpdatingLocation"
			case .viewReceiveVehicleCustomer:
					return "viewReceiveVehicleCustomer"
			case .notificationForegroundServiceTextGetToDealership:
					return "notificationForegroundServiceTextGetToDealership"
			case .skip:
					return "skip"
			case .requestTaskChangedFromBackend:
					return "requestTaskChangedFromBackend"
			case .errorForcedUpgradeTitle:
					return "errorForcedUpgradeTitle"
			case .loanerColon:
					return "loanerColon"
			case .viewHelpOptionDetailEmailVolvo:
					return "viewHelpOptionDetailEmailVolvo"
			case .number1:
					return "number1"
			case .ok:
					return "ok"
			case .viewInspectCustomerMinPhotosWarning:
					return "viewInspectCustomerMinPhotosWarning"
			case .popupAlreadyStartedDrivingPositive:
					return "popupAlreadyStartedDrivingPositive"
			case .notificationForegroundServiceTextRetrieveVehicle:
					return "notificationForegroundServiceTextRetrieveVehicle"
			case .popupGetToCustomerCopyToClipboard:
					return "popupGetToCustomerCopyToClipboard"
			case .popupPhoneVerificationResendCodeMessage:
					return "popupPhoneVerificationResendCodeMessage"
			case .requestCompleted:
					return "requestCompleted"
			case .viewSwipeButtonInnerText:
					return "viewSwipeButtonInnerText"
			case .viewScheduleEmpty:
					return "viewScheduleEmpty"
			case .settings:
					return "settings"
			case .viewInspectCustomerOverlayInfo:
					return "viewInspectCustomerOverlayInfo"
			case .viewStartRequestPickup:
					return "viewStartRequestPickup"
			case .permissionsLocationDeniedMessage:
					return "permissionsLocationDeniedMessage"
			case .number5:
					return "number5"
			case .viewInspectDocumentsOverlayInfo:
					return "viewInspectDocumentsOverlayInfo"
			case .popupAddNewLocationLabel:
					return "popupAddNewLocationLabel"
			case .viewInspectNotesDescriptionHint:
					return "viewInspectNotesDescriptionHint"
			case .errorIllegalRequestStateChange:
					return "errorIllegalRequestStateChange"
			case .error:
					return "error"
			case .viewDrivetoArriveatCustomer:
					return "viewDrivetoArriveatCustomer"
			case .errorVerifyPhoneNumber:
					return "errorVerifyPhoneNumber"
			case .errorLocationOutOfDropoffArea:
					return "errorLocationOutOfDropoffArea"
			case .number7:
					return "number7"
			case .errorInvalidCredentials:
					return "errorInvalidCredentials"
			case .viewDrivetoCustomer:
					return "viewDrivetoCustomer"
			case .errorRemoveVehicleError:
					return "errorRemoveVehicleError"
			case .errorIllegalRequestTaskChange:
					return "errorIllegalRequestTaskChange"
			case .requestReset:
					return "requestReset"
			case .vehicleMake:
					return "vehicleMake"
			case .popupGetToDealershipCopyToClipboard:
					return "popupGetToDealershipCopyToClipboard"
			case .viewContactText:
					return "viewContactText"
			case .viewProfileChangeContact:
					return "viewProfileChangeContact"
			case .errorAmbiguousCustomerUpsert:
					return "errorAmbiguousCustomerUpsert"
			case .dismiss:
					return "dismiss"
			case .viewExchangeKeysPickupSwipeTitle:
					return "viewExchangeKeysPickupSwipeTitle"
			case .errorUnknown:
					return "errorUnknown"
			case .viewGettoDealershipSwipeButtonTitle:
					return "viewGettoDealershipSwipeButtonTitle"
			case .notificationForegroundServiceTextDriverMeetWithCustomer:
					return "notificationForegroundServiceTextDriverMeetWithCustomer"
			case .viewDrawerProfileOptionsChangePassword:
					return "viewDrawerProfileOptionsChangePassword"
			case .viewRetrieveFormsInfoNext:
					return "viewRetrieveFormsInfoNext"
			case .signout:
					return "signout"
			case .phoneNumberAlreadyTaken:
					return "phoneNumberAlreadyTaken"
			case .no:
					return "no"
			case .errorInvalidLastName:
					return "errorInvalidLastName"
			case .viewReceiveVehicleLoanerNext:
					return "viewReceiveVehicleLoanerNext"
			case .support:
					return "support"
			case .inspectVehicle:
					return "inspectVehicle"
			case .viewDrawerNavigationPreferenceGoogle:
					return "viewDrawerNavigationPreferenceGoogle"
			case .viewReceiveVehicle:
					return "viewReceiveVehicle"
			case .viewScheduleListHeaderNameUpcomingToday:
					return "viewScheduleListHeaderNameUpcomingToday"
			case .number11:
					return "number11"
			case .viewReceiveVehicleLoanerSwipeButtonTitle:
					return "viewReceiveVehicleLoanerSwipeButtonTitle"
			case .notificationForegroundServiceTextRetrieveLoaner:
					return "notificationForegroundServiceTextRetrieveLoaner"
			case .retry:
					return "retry"
			case .number2:
					return "number2"
			case .viewSchedule:
					return "viewSchedule"
			case .viewExchangeKeysSwipeButtonTitle:
					return "viewExchangeKeysSwipeButtonTitle"
			case .viewHelpCategoryLastLeg:
					return "viewHelpCategoryLastLeg"
			case .licensePlateColon:
					return "licensePlateColon"
			case .openSettings:
					return "openSettings"
			case .yourAccount:
					return "yourAccount"
			case .unknown:
					return "unknown"
			case .viewStartRequestRetrieveForms:
					return "viewStartRequestRetrieveForms"
			case .notificationActionOpen:
					return "notificationActionOpen"
			case .viewInspectNotesSwipeButtonTitle:
					return "viewInspectNotesSwipeButtonTitle"
			case .errorPasswordNotMatch:
					return "errorPasswordNotMatch"
			case .viewEmailSubject:
					return "viewEmailSubject"
			case .popupMileageMaxConfirmation:
					return "popupMileageMaxConfirmation"
			case .serviceColon:
					return "serviceColon"
			case .notificationForegroundServiceTextDriveCustomerToDealership:
					return "notificationForegroundServiceTextDriveCustomerToDealership"
			case .errorInvalidUserDisabled:
					return "errorInvalidUserDisabled"
			case .viewScheduleServiceStatusSelfAdvisorPickup:
					return "viewScheduleServiceStatusSelfAdvisorPickup"
			case .errorOops:
					return "errorOops"
			case .viewScheduleListHeaderNameCurrent:
					return "viewScheduleListHeaderNameCurrent"
			case .viewSigninPhoto:
					return "viewSigninPhoto"
			case .viewDrawerNavigationPreferenceTitle:
					return "viewDrawerNavigationPreferenceTitle"
			case .viewExchangeKeysDeliverySwipeTitle:
					return "viewExchangeKeysDeliverySwipeTitle"
			case .errorInvalidPasswordUnauthorizedCharacters:
					return "errorInvalidPasswordUnauthorizedCharacters"
			case .yes:
					return "yes"
			case .popupTooFarFromDealershipTitle:
					return "popupTooFarFromDealershipTitle"
			case .viewRecordLoanerMileagePickupSwipeButtonTitle:
					return "viewRecordLoanerMileagePickupSwipeButtonTitle"
			case .inspectVehicles:
					return "inspectVehicles"
			case .viewScheduleEmptyToday:
					return "viewScheduleEmptyToday"
			case .viewInspectDocumentsMinPhotoWarning:
					return "viewInspectDocumentsMinPhotoWarning"
			case .model:
					return "model"
			case .viewNavigateAddressCopiedToClipboard:
					return "viewNavigateAddressCopiedToClipboard"
			case .viewTosContent:
					return "viewTosContent"
			case .viewScheduleServiceStatusSelfFooterTitleDropoff:
					return "viewScheduleServiceStatusSelfFooterTitleDropoff"
			case .viewDrivetoSwipeButtonTitle:
					return "viewDrivetoSwipeButtonTitle"
			case .errorSoftUpgradeMessage:
					return "errorSoftUpgradeMessage"
			case .errorInvalidPassword:
					return "errorInvalidPassword"
			case .errorPhoneNumberTaken:
					return "errorPhoneNumberTaken"
			case .viewInspectLoanerMinPhotoWarning:
					return "viewInspectLoanerMinPhotoWarning"
			case .popupTooFarFromCustomerPositive:
					return "popupTooFarFromCustomerPositive"
			case .number9:
					return "number9"
			case .viewReceiveVehicleCustomerSwipeButtonTitle:
					return "viewReceiveVehicleCustomerSwipeButtonTitle"
			case .notificationForegroundServiceTextDriveLoanerToDealership:
					return "notificationForegroundServiceTextDriveLoanerToDealership"
			case .viewTosContentPrivacyPolicy:
					return "viewTosContentPrivacyPolicy"
			case .viewArrivedatDeliverySwipeButtonTitle:
					return "viewArrivedatDeliverySwipeButtonTitle"
			case .viewInspectLoanerMinPhotosWarning:
					return "viewInspectLoanerMinPhotosWarning"
			case .contact:
					return "contact"
			case .min:
					return "min"
			case .viewStartRequestDropoff:
					return "viewStartRequestDropoff"
			case .viewScheduleServiceStatusSelfAdvisorDropoff:
					return "viewScheduleServiceStatusSelfAdvisorDropoff"
			case .emailAddress:
					return "emailAddress"
			case .number4:
					return "number4"
			case .errorUserDisabled:
					return "errorUserDisabled"
			case .update:
					return "update"
			case .viewSignupPasswordRequireNumber:
					return "viewSignupPasswordRequireNumber"
			case .viewSignin:
					return "viewSignin"
			case .change:
					return "change"
			case .viewRetrieveVehicleLoanerSwipeTitle:
					return "viewRetrieveVehicleLoanerSwipeTitle"
			case .notificationBatteryWarningTitle:
					return "notificationBatteryWarningTitle"
			case .viewDrawerProfileOptionsChangeContact:
					return "viewDrawerProfileOptionsChangeContact"
			case .viewSigninEmailInvalid:
					return "viewSigninEmailInvalid"
			case .viewHelpCategoryTroubleWithLuxeByVolvoApp:
					return "viewHelpCategoryTroubleWithLuxeByVolvoApp"
			case .notificationForegroundServiceTextDriverInspectLoaner:
					return "notificationForegroundServiceTextDriverInspectLoaner"
			case .popupGetToCustomerTitle:
					return "popupGetToCustomerTitle"
			case .exchangeKeys:
					return "exchangeKeys"
			case .viewReceiveVehicleLoaner:
					return "viewReceiveVehicleLoaner"
			case .errorInvalidApplicationVersion:
					return "errorInvalidApplicationVersion"
			case .viewStartRequestRetrieveCustomerVehicle:
					return "viewStartRequestRetrieveCustomerVehicle"
			case .viewSignupPasswordRequireLetter:
					return "viewSignupPasswordRequireLetter"
			case .viewDrawerProfileOptionsSignout:
					return "viewDrawerProfileOptionsSignout"
			case .viewSoftwareLicences:
					return "viewSoftwareLicences"
			case .errorInvalidPhoneNumber:
					return "errorInvalidPhoneNumber"
			case .viewHelpOptionDetailCallDealer:
					return "viewHelpOptionDetailCallDealer"
			case .popupAlreadyStartedDrivingMessage:
					return "popupAlreadyStartedDrivingMessage"
			case .requestCanceled:
					return "requestCanceled"
			case .viewDrawerProfileOptionsAttributions:
					return "viewDrawerProfileOptionsAttributions"
			case .viewSigninPasswordShort:
					return "viewSigninPasswordShort"
			case .viewLogoTitle:
					return "viewLogoTitle"
			case .viewTosContentPrivacyPolicyTitle:
					return "viewTosContentPrivacyPolicyTitle"
			case .number8:
					return "number8"
			case .viewScheduleStateRefreshButton:
					return "viewScheduleStateRefreshButton"
			case .viewEmailIntentChooserTitle:
					return "viewEmailIntentChooserTitle"
			case .viewReceiveVehicleInfoReminder:
					return "viewReceiveVehicleInfoReminder"
			case .viewRecordLoanerMileageDropoffInfoNext:
					return "viewRecordLoanerMileageDropoffInfoNext"
			case .edit:
					return "edit"
			case .viewDriveto:
					return "viewDriveto"
			case .viewTosContentPrivacyPolicyUrl:
					return "viewTosContentPrivacyPolicyUrl"
			case .cancel:
					return "cancel"
			case .popupSignoutConfirmationMessage:
					return "popupSignoutConfirmationMessage"
			case .done:
					return "done"
			case .viewGettoCustomerArriveatCustomer:
					return "viewGettoCustomerArriveatCustomer"
			case .viewSigninPopupProgressSignin:
					return "viewSigninPopupProgressSignin"
			case .pickupColon:
					return "pickupColon"
			case .viewInspectLoanerOverlayInfo:
					return "viewInspectLoanerOverlayInfo"
			case .viewScheduleStateRefreshInfo:
					return "viewScheduleStateRefreshInfo"
			case .errorLocationServiceUnavailable:
					return "errorLocationServiceUnavailable"
			case .errorInvalidPhoneVerificationCode:
					return "errorInvalidPhoneVerificationCode"
			case .viewInspectDocumentsMinPhotosWarning:
					return "viewInspectDocumentsMinPhotosWarning"
			case .recentMileageColon:
					return "recentMileageColon"
			case .viewRecordLoanerMileage:
					return "viewRecordLoanerMileage"
			case .appName:
					return "appName"
			case .popupGetToDealershipTitle:
					return "popupGetToDealershipTitle"
			case .errorInvalidFirstName:
					return "errorInvalidFirstName"
			case .popupTooFarFromCustomerTitle:
					return "popupTooFarFromCustomerTitle"
			case .viewProfileChangePasswordTemp:
					return "viewProfileChangePasswordTemp"
			case .color:
					return "color"
			case .newPassword:
					return "newPassword"
			case .goBack:
					return "goBack"
			case .notificationForegroundServiceTextRetrieveForms:
					return "notificationForegroundServiceTextRetrieveForms"
			case .exchangeKey:
					return "exchangeKey"
			case .viewExchangeKeysInfoReminder:
					return "viewExchangeKeysInfoReminder"
			case .viewTosContentTermsOfServiceUrl:
					return "viewTosContentTermsOfServiceUrl"
			case .number10:
					return "number10"
			case .viewStartRequestRetrieveLoaner:
					return "viewStartRequestRetrieveLoaner"
			case .viewScheduleState:
					return "viewScheduleState"
			case .popupDeviceChangeTitle:
					return "popupDeviceChangeTitle"
			case .errorFaceDetectionMessage:
					return "errorFaceDetectionMessage"
			case .notesColon:
					return "notesColon"
			case .viewRetrieveForms:
					return "viewRetrieveForms"
			case .viewTosContentTermsOfServiceTitle:
					return "viewTosContentTermsOfServiceTitle"
			case .viewRetrieveVehicleCustomerSwipeTitle:
					return "viewRetrieveVehicleCustomerSwipeTitle"
			case .viewNavigateWazeText:
					return "viewNavigateWazeText"
			case .errorOnline:
					return "errorOnline"
			case .remove:
					return "remove"
			case .pickup:
					return "pickup"
			case .viewIntro:
					return "viewIntro"
			case .volvoYearModel:
					return "volvoYearModel"
			case .permissionsCameraDeniedMessage:
					return "permissionsCameraDeniedMessage"
			case .viewContactCall:
					return "viewContactCall"
			case .errorRequestNotCancelable:
					return "errorRequestNotCancelable"
			case .currentPassword:
					return "currentPassword"
			case .viewDrawerNavigationPreferenceWaze:
					return "viewDrawerNavigationPreferenceWaze"
			case .viewGetToText:
					return "viewGetToText"
			case .errorDuplicateLoanerVehicleBookingAssignment:
					return "errorDuplicateLoanerVehicleBookingAssignment"
			case .viewSigninForgotPassword:
					return "viewSigninForgotPassword"
			case .popupSoftUpgradeNegative:
					return "popupSoftUpgradeNegative"
			case .popupPhoneVerificationResendCodeTitle:
					return "popupPhoneVerificationResendCodeTitle"
			case .viewInspectNotes:
					return "viewInspectNotes"
			case .viewScheduleListHeaderNameCompletedToday:
					return "viewScheduleListHeaderNameCompletedToday"
			case .notificationBatteryWarningText:
					return "notificationBatteryWarningText"
			case .toastSettingsLocationDisabled:
					return "toastSettingsLocationDisabled"
			case .repairOrderColon:
					return "repairOrderColon"
			case .notificationForegroundServiceTextDriverGetToCustomer:
					return "notificationForegroundServiceTextDriverGetToCustomer"
			case .helpICantUpdateMyPhone:
					return "helpICantUpdateMyPhone"
			case .viewGettoCustomerSwipeButtonTitle:
					return "viewGettoCustomerSwipeButtonTitle"
			case .viewHelpOptionDetailEmailDealer:
					return "viewHelpOptionDetailEmailDealer"
			case .viewScheduleListItemTypeDeliver:
					return "viewScheduleListItemTypeDeliver"
			case .viewRetrieveVehicleCustomer:
					return "viewRetrieveVehicleCustomer"
			case .dealershipAddressColon:
					return "dealershipAddressColon"
			case .viewArrivedatPickupSwipeButtonTitle:
					return "viewArrivedatPickupSwipeButtonTitle"
			case .viewPhoneAddLabel:
					return "viewPhoneAddLabel"
			case .viewScheduleCurrent:
					return "viewScheduleCurrent"
			case .viewIntroFooterSignup:
					return "viewIntroFooterSignup"
			case .back:
					return "back"
			case .createPassword:
					return "createPassword"
			case .permissionsCameraDeniedTitle:
					return "permissionsCameraDeniedTitle"
			case .viewEmailBody:
					return "viewEmailBody"
			case .notificationForegroundServiceTextInspectNotes:
					return "notificationForegroundServiceTextInspectNotes"
			case .errorSoftUpgradeTitle:
					return "errorSoftUpgradeTitle"
			case .notificationForegroundServiceTextDriverInspectCustomer:
					return "notificationForegroundServiceTextDriverInspectCustomer"
			case .errorEnterLoanerMileage:
					return "errorEnterLoanerMileage"
			case .notificationForegroundServiceTextDriverVehicleToCustomer:
					return "notificationForegroundServiceTextDriverVehicleToCustomer"
			case .viewArrivedatCustomer:
					return "viewArrivedatCustomer"
			case .viewHelpOptionDetailCallVolvo:
					return "viewHelpOptionDetailCallVolvo"
			case .modelColon:
					return "modelColon"
			case .notificationForegroundServiceTextDriverExchangeKeys:
					return "notificationForegroundServiceTextDriverExchangeKeys"
			case .errorLocationOutOfPickupArea:
					return "errorLocationOutOfPickupArea"
			case .password:
					return "password"
			case .add:
					return "add"
			case .viewReturntoSwipeButtonTitle:
					return "viewReturntoSwipeButtonTitle"
			case .notNow:
					return "notNow"
			case .loading:
					return "loading"
			case .notificationForegroundServiceTextReceiveLoaner:
					return "notificationForegroundServiceTextReceiveLoaner"
			case .delivery:
					return "delivery"
			case .viewArrivedat:
					return "viewArrivedat"
			case .addressColon:
					return "addressColon"
			case .new:
					return "new"
			case .viewRetrieveVehicleCustomerInfoNext:
					return "viewRetrieveVehicleCustomerInfoNext"
			case .number3:
					return "number3"
			case .errorInvalidCharacter:
					return "errorInvalidCharacter"
			case .viewStartRequestSwipeButtonTitle:
					return "viewStartRequestSwipeButtonTitle"
			case .later:
					return "later"
			case .popupTooFarFromCustomerMessage:
					return "popupTooFarFromCustomerMessage"
			case .popupForgotPasswordTitle:
					return "popupForgotPasswordTitle"
			case .updateNow:
					return "updateNow"
			case .deliveryColon:
					return "deliveryColon"
			case .errorInvalidPasswordConfirm:
					return "errorInvalidPasswordConfirm"
			case .popupSelectTimeSlotUnavailableCallDealership:
					return "popupSelectTimeSlotUnavailableCallDealership"
			case .returnToDealership:
					return "returnToDealership"
			case .phoneNumber:
					return "phoneNumber"
			case .next:
					return "next"
			case .errorDatabase:
					return "errorDatabase"
			case .viewInspectCustomer:
					return "viewInspectCustomer"
			case .errorAccountAlreadyExists:
					return "errorAccountAlreadyExists"
			case .confirmNewPassword:
					return "confirmNewPassword"
			case .permissionsLocationDeniedTitle:
					return "permissionsLocationDeniedTitle"
			case .notificationForegroundServiceTextRecordLoanerMileage:
					return "notificationForegroundServiceTextRecordLoanerMileage"
			case .viewHelpCategoryHowLuxeByVolvoWorks:
					return "viewHelpCategoryHowLuxeByVolvoWorks"
			case .notificationForegroundServiceTitle:
					return "notificationForegroundServiceTitle"
			case .number6:
					return "number6"
			case .viewGettoCustomer:
					return "viewGettoCustomer"
			case .errorSynchingRequest:
					return "errorSynchingRequest"
			case .popupHardRefreshMessage:
					return "popupHardRefreshMessage"
			case .popupAlreadyStartedDrivingTitle:
					return "popupAlreadyStartedDrivingTitle"
			case .passwordRequirements:
					return "passwordRequirements"
			case .popupMileageMinConfirmation:
					return "popupMileageMinConfirmation"
			case .viewPhoneAdd:
					return "viewPhoneAdd"
			case .viewScheduleListItemTypePickup:
					return "viewScheduleListItemTypePickup"
			case .viewDrawerContactDealershipCall:
					return "viewDrawerContactDealershipCall"
			case .errorInvalidVerificationCode:
					return "errorInvalidVerificationCode"
			case .confirmPhoneNumber:
					return "confirmPhoneNumber"
			case .help:
					return "help"
			case .phoneNumberCannotBeEmpty:
					return "phoneNumberCannotBeEmpty"
			case .errorAmbiguousVehicleUpsert:
					return "errorAmbiguousVehicleUpsert"
			case .viewPhoneVerificationLabel:
					return "viewPhoneVerificationLabel"
			case .notificationBatteryWarningTextBig:
					return "notificationBatteryWarningTextBig"
			case .viewInspectCustomerMinPhotoWarning:
					return "viewInspectCustomerMinPhotoWarning"
			case .popupChooseDealershipTitle:
					return "popupChooseDealershipTitle"
			case .viewRetrieveFormsSwipeTitle:
					return "viewRetrieveFormsSwipeTitle"
			case .errorForcedUpgradeMessage:
					return "errorForcedUpgradeMessage"
			case .viewDrawerContactDealershipText:
					return "viewDrawerContactDealershipText"
			case .viewInspectLoaner:
					return "viewInspectLoaner"
			case .customerColon:
					return "customerColon"
			case .dealership:
					return "dealership"
			case .notificationForegroundServiceTextDriverInspectDocuments:
					return "notificationForegroundServiceTextDriverInspectDocuments"
			case .viewSigninActionSignin:
					return "viewSigninActionSignin"
			case .viewNavigateText:
					return "viewNavigateText"
			case .mins:
					return "mins"
			case .close:
					return "close"
			case .viewRecordLoanerMileageDropoffSwipeButtonTitle:
					return "viewRecordLoanerMileageDropoffSwipeButtonTitle"
			case .viewTosContentTermsOfService:
					return "viewTosContentTermsOfService"
			case .viewArrivedatDeliveryInspectVehicles:
					return "viewArrivedatDeliveryInspectVehicles"
			case .viewScheduleServiceStatusSelfDealershipNavigate:
					return "viewScheduleServiceStatusSelfDealershipNavigate"
			case .keyCodeColon:
					return "keyCodeColon"
			case .popupTooFarFromDealershipPositive:
					return "popupTooFarFromDealershipPositive"
			case .popupTooFarFromDealershipMessage:
					return "popupTooFarFromDealershipMessage"
			case .errorInvalidEmail:
					return "errorInvalidEmail"
			case .viewRetrieveVehicle:
					return "viewRetrieveVehicle"
			case .popupForgotPasswordMessage:
					return "popupForgotPasswordMessage"
			case .resendCode:
					return "resendCode"
			case .helpIForgotMyPassword:
					return "helpIForgotMyPassword"
			case .notAvailable:
					return "notAvailable"
			case .year:
					return "year"
			case .viewChecklistLoanerAgreementLabel:
					return "viewChecklistLoanerAgreementLabel"
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
