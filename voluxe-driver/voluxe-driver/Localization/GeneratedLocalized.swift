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
    
    case licensePlateColon
	case viewDrawerContactDealershipText
	case errorInvalidCredentials
	case min
	case errorRemoveVehicleError
	case viewExchangeKeysDeliverySwipeTitle
	case errorLocationServiceUnavailable
	case viewArrivedatPickupSwipeButtonTitle
	case requestReset
	case viewReceiveVehicleInfoReminder
	case notificationActionOpen
	case viewInspectNotesSwipeButtonTitle
	case errorAmbiguousVehicleUpsert
	case viewInspectDocumentsOverlayInfo
	case resendCode
	case popupDeviceChangeMessage
	case notNow
	case number3
	case errorInvalidPasswordUnauthorizedCharacters
	case number10
	case errorInvalidPasswordConfirm
	case viewInspectCustomer
	case viewScheduleEmptyToday
	case popupSignoutConfirmationMessage
	case popupGetToCustomerTitle
	case errorInvalidCharacter
	case errorDuplicateLoanerVehicleBookingAssignment
	case viewDrawerNavigationPreferenceWaze
	case confirmPhoneNumber
	case viewRetrieveVehicleCustomerInfoNext
	case passwordRequirements
	case viewInspectDocuments
	case viewEmailSubject
	case viewScheduleListHeaderNameCurrent
	case viewArrivedatDeliverySwipeButtonTitle
	case requestCompleted
	case viewExchangeKeysPickupSwipeTitle
	case viewRecordLoanerMileage
	case viewScheduleCurrent
	case viewDrawerProfileOptionsSignout
	case close
	case viewExchangeKeysSwipeButtonTitle
	case viewSigninPhoto
	case goBack
	case notificationForegroundServiceTextRecordLoanerMileage
	case pickup
	case unknown
	case viewReturntoSwipeButtonTitle
	case popupMileageMinConfirmation
	case viewGettoCustomerArriveatCustomer
	case notificationForegroundServiceTextDriverExchangeKeys
	case delivery
	case viewSigninActionSignin
	case viewReceiveVehicleLoaner
	case createPassword
	case popupTooFarFromCustomerMessage
	case viewTosContentPrivacyPolicy
	case viewRetrieveVehicle
	case done
	case dismiss
	case popupForgotPasswordTitle
	case viewIntroFooterSignup
	case notificationBatteryWarningTitle
	case viewInspectCustomerMinPhotoWarning
	case errorIllegalRequestTaskChange
	case popupAlreadyStartedDrivingPositive
	case viewInspectDocumentsMinPhotosWarning
	case viewSigninForgotPassword
	case popupHardRefreshTitle
	case next
	case popupPhoneVerificationResendCodeMessage
	case notificationForegroundServiceTextInspectNotes
	case viewRetrieveVehicleCustomer
	case number1
	case viewScheduleListHeaderNameUpcomingToday
	case number6
	case viewDrawerContactDealershipCall
	case popupTooFarFromCustomerPositive
	case update
	case viewInspectLoaner
	case newPassword
	case viewDriveto
	case notificationForegroundServiceTitle
	case no
	case viewArrivedatDeliveryInspectVehicles
	case popupUpdatingLocation
	case viewInspectNotes
	case skip
	case viewNavigateWazeText
	case viewPhoneAdd
	case errorDatabase
	case errorEnterLoanerMileage
	case viewReceiveVehicleCustomer
	case errorPhoneNumberTaken
	case viewReceiveVehicleLoanerSwipeButtonTitle
	case permissionsLocationDeniedTitle
	case errorInvalidApplicationVersion
	case errorAccountAlreadyExists
	case errorSynchingRequest
	case viewNavigateAddressCopiedToClipboard
	case viewScheduleServiceStatusSelfAdvisorPickup
	case mins
	case notificationForegroundServiceTextRetrieveVehicle
	case retry
	case notificationForegroundServiceTextDriverGetToCustomer
	case appName
	case password
	case errorIllegalRequestStateChange
	case viewProfileChangeContact
	case viewDrivetoCustomer
	case viewReceiveVehicleLoanerNext
	case viewGettoCustomerSwipeButtonTitle
	case viewScheduleListItemTypeDeliver
	case readMore
	case viewTosContentPrivacyPolicyUrl
	case change
	case viewExchangeKeysInfoReminder
	case viewTosContent
	case viewSigninPopupProgressSignin
	case viewScheduleState
	case viewStartRequestRetrieveCustomerVehicle
	case viewDrawerProfileOptionsAttributions
	case viewHelpCategoryHowLuxeByVolvoWorks
	case customerColon
	case viewSigninEmailInvalid
	case color
	case number4
	case helpIForgotMyPassword
	case phoneNumberCannotBeEmpty
	case notesColon
	case later
	case viewSignin
	case popupMileageMaxConfirmation
	case viewReceiveVehicleCustomerSwipeButtonTitle
	case viewRetrieveFormsInfoNext
	case keyCodeColon
	case confirmationCode
	case errorOnline
	case notificationForegroundServiceTextRetrieveForms
	case error
	case viewDrawerNavigationPreferenceTitle
	case number11
	case viewScheduleServiceStatusSelfFooterTitleDropoff
	case viewHelpOptionDetailCallVolvo
	case emailAddress
	case notificationBatteryWarningTextBig
	case viewChecklistLoanerAgreementLabel
	case errorInvalidPassword
	case popupPhoneVerificationResendCodeTitle
	case exchangeKeys
	case popupHardRefreshMessage
	case viewSchedule
	case ok
	case errorInvalidUserDisabled
	case addressColon
	case popupSoftUpgradeNegative
	case inspectVehicles
	case errorVerifyPhoneNumber
	case viewScheduleStateRefreshInfo
	case viewScheduleServiceStatusSelfAdvisorDropoff
	case viewSwipeButtonInnerText
	case viewRetrieveFormsSwipeTitle
	case notificationForegroundServiceTextDriveCustomerToDealership
	case viewInspectNotesDescriptionHint
	case viewGetToText
	case viewTosContentTermsOfServiceUrl
	case viewScheduleListHeaderNameCompletedToday
	case loading
	case currentPassword
	case number8
	case phoneNumberAlreadyTaken
	case viewRetrieveForms
	case contact
	case notificationForegroundServiceTextReceiveLoaner
	case viewRecordLoanerMileageDropoffSwipeButtonTitle
	case viewEmailIntentChooserTitle
	case support
	case loanerColon
	case errorLocationServiceNotOfferedInYourArea
	case viewInspectLoanerMinPhotoWarning
	case viewStartRequestPickup
	case popupTooFarFromCustomerTitle
	case viewRecordLoanerMileagePickupSwipeButtonTitle
	case edit
	case viewStartRequestRetrieveLoaner
	case viewDrawerProfileOptionsChangeContact
	case errorUnknown
	case volvoYearModel
	case errorOops
	case number7
	case modelColon
	case year
	case dealership
	case viewInspectCustomerOverlayInfo
	case notificationForegroundServiceTextRetrieveLoaner
	case errorSoftUpgradeMessage
	case viewHelpCategoryLastLeg
	case popupGetToDealershipTitle
	case errorInvalidLastName
	case openSettings
	case viewScheduleServiceStatusSelfDealershipNavigate
	case errorForcedUpgradeMessage
	case dealershipAddressColon
	case viewTosContentTermsOfService
	case viewNavigateText
	case requestTaskChangedFromBackend
	case popupGetToCustomerCopyToClipboard
	case viewHelpCategoryTroubleWithLuxeByVolvoApp
	case popupGetToDealershipCopyToClipboard
	case popupChooseDealershipTitle
	case iAmSure
	case viewSignupPasswordRequireLetter
	case permissionsLocationDeniedMessage
	case notificationBatteryWarningText
	case popupAlreadyStartedDrivingMessage
	case yes
	case returnToDealership
	case pickupColon
	case settings
	case notificationForegroundServiceTextDriveLoanerToDealership
	case repairOrderColon
	case errorRequestNotCancelable
	case viewEmailBody
	case errorInvalidPhoneVerificationCode
	case popupTooFarFromDealershipPositive
	case helpICantUpdateMyPhone
	case signout
	case errorForcedUpgradeTitle
	case remove
	case viewStartRequestSwipeButtonTitle
	case errorInvalidEmail
	case confirmNewPassword
	case viewInspectLoanerOverlayInfo
	case viewInspectLoanerMinPhotosWarning
	case viewScheduleEmpty
	case viewRecordLoanerMileageDropoffInfoNext
	case viewArrivedatCustomer
	case popupAlreadyStartedDrivingTitle
	case errorUserDisabled
	case notAvailable
	case viewInspectDocumentsMinPhotoWarning
	case viewRetrieveVehicleCustomerSwipeTitle
	case help
	case updateNow
	case viewStartRequestRetrieveForms
	case errorSoftUpgradeTitle
	case yourAccount
	case viewContactText
	case cancel
	case errorInvalidVerificationCode
	case errorInvalidPhoneNumber
	case notificationForegroundServiceTextDriverInspectLoaner
	case popupForgotPasswordMessage
	case notificationForegroundServiceTextDriverVehicleToCustomer
	case viewContactCall
	case exchangeKey
	case model
	case recentMileageColon
	case errorInvalidFirstName
	case errorLocationOutOfDropoffArea
	case popupSelectTimeSlotUnavailableCallDealership
	case new
	case viewHelpOptionDetailEmailVolvo
	case viewScheduleServiceTypeOtherUnknown
	case number2
	case permissionsCameraDeniedTitle
	case viewIntroFooterSignin
	case errorOffline
	case viewProfileChangePasswordTemp
	case errorFaceDetectionMessage
	case phoneNumber
	case permissionsCameraDeniedMessage
	case popupTooFarFromDealershipTitle
	case number5
	case viewSigninPasswordShort
	case viewTosContentTermsOfServiceTitle
	case viewSignupPasswordRequireNumber
	case viewReceiveVehicle
	case viewLogoTitle
	case back
	case requestCanceled
	case errorAmbiguousCustomerUpsert
	case notificationForegroundServiceTextGetToDealership
	case viewDrivetoArriveatCustomer
	case notificationForegroundServiceTextDriverInspectDocuments
	case popupAddNewLocationLabel
	case add
	case deliveryColon
	case viewArrivedat
	case viewGettoCustomer
	case viewDrawerNavigationPreferenceGoogle
	case viewPhoneAddLabel
	case errorLocationOutOfPickupArea
	case popupTooFarFromDealershipMessage
	case number9
	case viewSoftwareLicences
	case viewHelpOptionDetailCallDealer
	case notificationForegroundServiceTextDriverInspectCustomer
	case viewPhoneVerificationLabel
	case notificationForegroundServiceTextDriverMeetWithCustomer
	case viewRetrieveVehicleLoaner
	case viewHelpOptionDetailEmailDealer
	case viewRetrieveVehicleLoanerSwipeTitle
	case toastSettingsLocationDisabled
	case viewDrawerProfileOptionsChangePassword
	case notificationForegroundServiceTextDriverLoanerToCustomer
	case viewDrivetoSwipeButtonTitle
	case inspectVehicle
	case viewInspectCustomerMinPhotosWarning
	case viewStartRequestDropoff
	case popupDeviceChangeTitle
	case viewScheduleStateRefreshButton
	case serviceColon
	case viewScheduleListItemTypePickup
	case viewTosContentPrivacyPolicyTitle
	case vehicleMake
	case errorPasswordNotMatch
	case viewGettoDealershipSwipeButtonTitle
	case viewIntro

    var key : String {
        switch self {
            case .licensePlateColon:
					return "licensePlateColon"
			case .viewDrawerContactDealershipText:
					return "viewDrawerContactDealershipText"
			case .errorInvalidCredentials:
					return "errorInvalidCredentials"
			case .min:
					return "min"
			case .errorRemoveVehicleError:
					return "errorRemoveVehicleError"
			case .viewExchangeKeysDeliverySwipeTitle:
					return "viewExchangeKeysDeliverySwipeTitle"
			case .errorLocationServiceUnavailable:
					return "errorLocationServiceUnavailable"
			case .viewArrivedatPickupSwipeButtonTitle:
					return "viewArrivedatPickupSwipeButtonTitle"
			case .requestReset:
					return "requestReset"
			case .viewReceiveVehicleInfoReminder:
					return "viewReceiveVehicleInfoReminder"
			case .notificationActionOpen:
					return "notificationActionOpen"
			case .viewInspectNotesSwipeButtonTitle:
					return "viewInspectNotesSwipeButtonTitle"
			case .errorAmbiguousVehicleUpsert:
					return "errorAmbiguousVehicleUpsert"
			case .viewInspectDocumentsOverlayInfo:
					return "viewInspectDocumentsOverlayInfo"
			case .resendCode:
					return "resendCode"
			case .popupDeviceChangeMessage:
					return "popupDeviceChangeMessage"
			case .notNow:
					return "notNow"
			case .number3:
					return "number3"
			case .errorInvalidPasswordUnauthorizedCharacters:
					return "errorInvalidPasswordUnauthorizedCharacters"
			case .number10:
					return "number10"
			case .errorInvalidPasswordConfirm:
					return "errorInvalidPasswordConfirm"
			case .viewInspectCustomer:
					return "viewInspectCustomer"
			case .viewScheduleEmptyToday:
					return "viewScheduleEmptyToday"
			case .popupSignoutConfirmationMessage:
					return "popupSignoutConfirmationMessage"
			case .popupGetToCustomerTitle:
					return "popupGetToCustomerTitle"
			case .errorInvalidCharacter:
					return "errorInvalidCharacter"
			case .errorDuplicateLoanerVehicleBookingAssignment:
					return "errorDuplicateLoanerVehicleBookingAssignment"
			case .viewDrawerNavigationPreferenceWaze:
					return "viewDrawerNavigationPreferenceWaze"
			case .confirmPhoneNumber:
					return "confirmPhoneNumber"
			case .viewRetrieveVehicleCustomerInfoNext:
					return "viewRetrieveVehicleCustomerInfoNext"
			case .passwordRequirements:
					return "passwordRequirements"
			case .viewInspectDocuments:
					return "viewInspectDocuments"
			case .viewEmailSubject:
					return "viewEmailSubject"
			case .viewScheduleListHeaderNameCurrent:
					return "viewScheduleListHeaderNameCurrent"
			case .viewArrivedatDeliverySwipeButtonTitle:
					return "viewArrivedatDeliverySwipeButtonTitle"
			case .requestCompleted:
					return "requestCompleted"
			case .viewExchangeKeysPickupSwipeTitle:
					return "viewExchangeKeysPickupSwipeTitle"
			case .viewRecordLoanerMileage:
					return "viewRecordLoanerMileage"
			case .viewScheduleCurrent:
					return "viewScheduleCurrent"
			case .viewDrawerProfileOptionsSignout:
					return "viewDrawerProfileOptionsSignout"
			case .close:
					return "close"
			case .viewExchangeKeysSwipeButtonTitle:
					return "viewExchangeKeysSwipeButtonTitle"
			case .viewSigninPhoto:
					return "viewSigninPhoto"
			case .goBack:
					return "goBack"
			case .notificationForegroundServiceTextRecordLoanerMileage:
					return "notificationForegroundServiceTextRecordLoanerMileage"
			case .pickup:
					return "pickup"
			case .unknown:
					return "unknown"
			case .viewReturntoSwipeButtonTitle:
					return "viewReturntoSwipeButtonTitle"
			case .popupMileageMinConfirmation:
					return "popupMileageMinConfirmation"
			case .viewGettoCustomerArriveatCustomer:
					return "viewGettoCustomerArriveatCustomer"
			case .notificationForegroundServiceTextDriverExchangeKeys:
					return "notificationForegroundServiceTextDriverExchangeKeys"
			case .delivery:
					return "delivery"
			case .viewSigninActionSignin:
					return "viewSigninActionSignin"
			case .viewReceiveVehicleLoaner:
					return "viewReceiveVehicleLoaner"
			case .createPassword:
					return "createPassword"
			case .popupTooFarFromCustomerMessage:
					return "popupTooFarFromCustomerMessage"
			case .viewTosContentPrivacyPolicy:
					return "viewTosContentPrivacyPolicy"
			case .viewRetrieveVehicle:
					return "viewRetrieveVehicle"
			case .done:
					return "done"
			case .dismiss:
					return "dismiss"
			case .popupForgotPasswordTitle:
					return "popupForgotPasswordTitle"
			case .viewIntroFooterSignup:
					return "viewIntroFooterSignup"
			case .notificationBatteryWarningTitle:
					return "notificationBatteryWarningTitle"
			case .viewInspectCustomerMinPhotoWarning:
					return "viewInspectCustomerMinPhotoWarning"
			case .errorIllegalRequestTaskChange:
					return "errorIllegalRequestTaskChange"
			case .popupAlreadyStartedDrivingPositive:
					return "popupAlreadyStartedDrivingPositive"
			case .viewInspectDocumentsMinPhotosWarning:
					return "viewInspectDocumentsMinPhotosWarning"
			case .viewSigninForgotPassword:
					return "viewSigninForgotPassword"
			case .popupHardRefreshTitle:
					return "popupHardRefreshTitle"
			case .next:
					return "next"
			case .popupPhoneVerificationResendCodeMessage:
					return "popupPhoneVerificationResendCodeMessage"
			case .notificationForegroundServiceTextInspectNotes:
					return "notificationForegroundServiceTextInspectNotes"
			case .viewRetrieveVehicleCustomer:
					return "viewRetrieveVehicleCustomer"
			case .number1:
					return "number1"
			case .viewScheduleListHeaderNameUpcomingToday:
					return "viewScheduleListHeaderNameUpcomingToday"
			case .number6:
					return "number6"
			case .viewDrawerContactDealershipCall:
					return "viewDrawerContactDealershipCall"
			case .popupTooFarFromCustomerPositive:
					return "popupTooFarFromCustomerPositive"
			case .update:
					return "update"
			case .viewInspectLoaner:
					return "viewInspectLoaner"
			case .newPassword:
					return "newPassword"
			case .viewDriveto:
					return "viewDriveto"
			case .notificationForegroundServiceTitle:
					return "notificationForegroundServiceTitle"
			case .no:
					return "no"
			case .viewArrivedatDeliveryInspectVehicles:
					return "viewArrivedatDeliveryInspectVehicles"
			case .popupUpdatingLocation:
					return "popupUpdatingLocation"
			case .viewInspectNotes:
					return "viewInspectNotes"
			case .skip:
					return "skip"
			case .viewNavigateWazeText:
					return "viewNavigateWazeText"
			case .viewPhoneAdd:
					return "viewPhoneAdd"
			case .errorDatabase:
					return "errorDatabase"
			case .errorEnterLoanerMileage:
					return "errorEnterLoanerMileage"
			case .viewReceiveVehicleCustomer:
					return "viewReceiveVehicleCustomer"
			case .errorPhoneNumberTaken:
					return "errorPhoneNumberTaken"
			case .viewReceiveVehicleLoanerSwipeButtonTitle:
					return "viewReceiveVehicleLoanerSwipeButtonTitle"
			case .permissionsLocationDeniedTitle:
					return "permissionsLocationDeniedTitle"
			case .errorInvalidApplicationVersion:
					return "errorInvalidApplicationVersion"
			case .errorAccountAlreadyExists:
					return "errorAccountAlreadyExists"
			case .errorSynchingRequest:
					return "errorSynchingRequest"
			case .viewNavigateAddressCopiedToClipboard:
					return "viewNavigateAddressCopiedToClipboard"
			case .viewScheduleServiceStatusSelfAdvisorPickup:
					return "viewScheduleServiceStatusSelfAdvisorPickup"
			case .mins:
					return "mins"
			case .notificationForegroundServiceTextRetrieveVehicle:
					return "notificationForegroundServiceTextRetrieveVehicle"
			case .retry:
					return "retry"
			case .notificationForegroundServiceTextDriverGetToCustomer:
					return "notificationForegroundServiceTextDriverGetToCustomer"
			case .appName:
					return "appName"
			case .password:
					return "password"
			case .errorIllegalRequestStateChange:
					return "errorIllegalRequestStateChange"
			case .viewProfileChangeContact:
					return "viewProfileChangeContact"
			case .viewDrivetoCustomer:
					return "viewDrivetoCustomer"
			case .viewReceiveVehicleLoanerNext:
					return "viewReceiveVehicleLoanerNext"
			case .viewGettoCustomerSwipeButtonTitle:
					return "viewGettoCustomerSwipeButtonTitle"
			case .viewScheduleListItemTypeDeliver:
					return "viewScheduleListItemTypeDeliver"
			case .readMore:
					return "readMore"
			case .viewTosContentPrivacyPolicyUrl:
					return "viewTosContentPrivacyPolicyUrl"
			case .change:
					return "change"
			case .viewExchangeKeysInfoReminder:
					return "viewExchangeKeysInfoReminder"
			case .viewTosContent:
					return "viewTosContent"
			case .viewSigninPopupProgressSignin:
					return "viewSigninPopupProgressSignin"
			case .viewScheduleState:
					return "viewScheduleState"
			case .viewStartRequestRetrieveCustomerVehicle:
					return "viewStartRequestRetrieveCustomerVehicle"
			case .viewDrawerProfileOptionsAttributions:
					return "viewDrawerProfileOptionsAttributions"
			case .viewHelpCategoryHowLuxeByVolvoWorks:
					return "viewHelpCategoryHowLuxeByVolvoWorks"
			case .customerColon:
					return "customerColon"
			case .viewSigninEmailInvalid:
					return "viewSigninEmailInvalid"
			case .color:
					return "color"
			case .number4:
					return "number4"
			case .helpIForgotMyPassword:
					return "helpIForgotMyPassword"
			case .phoneNumberCannotBeEmpty:
					return "phoneNumberCannotBeEmpty"
			case .notesColon:
					return "notesColon"
			case .later:
					return "later"
			case .viewSignin:
					return "viewSignin"
			case .popupMileageMaxConfirmation:
					return "popupMileageMaxConfirmation"
			case .viewReceiveVehicleCustomerSwipeButtonTitle:
					return "viewReceiveVehicleCustomerSwipeButtonTitle"
			case .viewRetrieveFormsInfoNext:
					return "viewRetrieveFormsInfoNext"
			case .keyCodeColon:
					return "keyCodeColon"
			case .confirmationCode:
					return "confirmationCode"
			case .errorOnline:
					return "errorOnline"
			case .notificationForegroundServiceTextRetrieveForms:
					return "notificationForegroundServiceTextRetrieveForms"
			case .error:
					return "error"
			case .viewDrawerNavigationPreferenceTitle:
					return "viewDrawerNavigationPreferenceTitle"
			case .number11:
					return "number11"
			case .viewScheduleServiceStatusSelfFooterTitleDropoff:
					return "viewScheduleServiceStatusSelfFooterTitleDropoff"
			case .viewHelpOptionDetailCallVolvo:
					return "viewHelpOptionDetailCallVolvo"
			case .emailAddress:
					return "emailAddress"
			case .notificationBatteryWarningTextBig:
					return "notificationBatteryWarningTextBig"
			case .viewChecklistLoanerAgreementLabel:
					return "viewChecklistLoanerAgreementLabel"
			case .errorInvalidPassword:
					return "errorInvalidPassword"
			case .popupPhoneVerificationResendCodeTitle:
					return "popupPhoneVerificationResendCodeTitle"
			case .exchangeKeys:
					return "exchangeKeys"
			case .popupHardRefreshMessage:
					return "popupHardRefreshMessage"
			case .viewSchedule:
					return "viewSchedule"
			case .ok:
					return "ok"
			case .errorInvalidUserDisabled:
					return "errorInvalidUserDisabled"
			case .addressColon:
					return "addressColon"
			case .popupSoftUpgradeNegative:
					return "popupSoftUpgradeNegative"
			case .inspectVehicles:
					return "inspectVehicles"
			case .errorVerifyPhoneNumber:
					return "errorVerifyPhoneNumber"
			case .viewScheduleStateRefreshInfo:
					return "viewScheduleStateRefreshInfo"
			case .viewScheduleServiceStatusSelfAdvisorDropoff:
					return "viewScheduleServiceStatusSelfAdvisorDropoff"
			case .viewSwipeButtonInnerText:
					return "viewSwipeButtonInnerText"
			case .viewRetrieveFormsSwipeTitle:
					return "viewRetrieveFormsSwipeTitle"
			case .notificationForegroundServiceTextDriveCustomerToDealership:
					return "notificationForegroundServiceTextDriveCustomerToDealership"
			case .viewInspectNotesDescriptionHint:
					return "viewInspectNotesDescriptionHint"
			case .viewGetToText:
					return "viewGetToText"
			case .viewTosContentTermsOfServiceUrl:
					return "viewTosContentTermsOfServiceUrl"
			case .viewScheduleListHeaderNameCompletedToday:
					return "viewScheduleListHeaderNameCompletedToday"
			case .loading:
					return "loading"
			case .currentPassword:
					return "currentPassword"
			case .number8:
					return "number8"
			case .phoneNumberAlreadyTaken:
					return "phoneNumberAlreadyTaken"
			case .viewRetrieveForms:
					return "viewRetrieveForms"
			case .contact:
					return "contact"
			case .notificationForegroundServiceTextReceiveLoaner:
					return "notificationForegroundServiceTextReceiveLoaner"
			case .viewRecordLoanerMileageDropoffSwipeButtonTitle:
					return "viewRecordLoanerMileageDropoffSwipeButtonTitle"
			case .viewEmailIntentChooserTitle:
					return "viewEmailIntentChooserTitle"
			case .support:
					return "support"
			case .loanerColon:
					return "loanerColon"
			case .errorLocationServiceNotOfferedInYourArea:
					return "errorLocationServiceNotOfferedInYourArea"
			case .viewInspectLoanerMinPhotoWarning:
					return "viewInspectLoanerMinPhotoWarning"
			case .viewStartRequestPickup:
					return "viewStartRequestPickup"
			case .popupTooFarFromCustomerTitle:
					return "popupTooFarFromCustomerTitle"
			case .viewRecordLoanerMileagePickupSwipeButtonTitle:
					return "viewRecordLoanerMileagePickupSwipeButtonTitle"
			case .edit:
					return "edit"
			case .viewStartRequestRetrieveLoaner:
					return "viewStartRequestRetrieveLoaner"
			case .viewDrawerProfileOptionsChangeContact:
					return "viewDrawerProfileOptionsChangeContact"
			case .errorUnknown:
					return "errorUnknown"
			case .volvoYearModel:
					return "volvoYearModel"
			case .errorOops:
					return "errorOops"
			case .number7:
					return "number7"
			case .modelColon:
					return "modelColon"
			case .year:
					return "year"
			case .dealership:
					return "dealership"
			case .viewInspectCustomerOverlayInfo:
					return "viewInspectCustomerOverlayInfo"
			case .notificationForegroundServiceTextRetrieveLoaner:
					return "notificationForegroundServiceTextRetrieveLoaner"
			case .errorSoftUpgradeMessage:
					return "errorSoftUpgradeMessage"
			case .viewHelpCategoryLastLeg:
					return "viewHelpCategoryLastLeg"
			case .popupGetToDealershipTitle:
					return "popupGetToDealershipTitle"
			case .errorInvalidLastName:
					return "errorInvalidLastName"
			case .openSettings:
					return "openSettings"
			case .viewScheduleServiceStatusSelfDealershipNavigate:
					return "viewScheduleServiceStatusSelfDealershipNavigate"
			case .errorForcedUpgradeMessage:
					return "errorForcedUpgradeMessage"
			case .dealershipAddressColon:
					return "dealershipAddressColon"
			case .viewTosContentTermsOfService:
					return "viewTosContentTermsOfService"
			case .viewNavigateText:
					return "viewNavigateText"
			case .requestTaskChangedFromBackend:
					return "requestTaskChangedFromBackend"
			case .popupGetToCustomerCopyToClipboard:
					return "popupGetToCustomerCopyToClipboard"
			case .viewHelpCategoryTroubleWithLuxeByVolvoApp:
					return "viewHelpCategoryTroubleWithLuxeByVolvoApp"
			case .popupGetToDealershipCopyToClipboard:
					return "popupGetToDealershipCopyToClipboard"
			case .popupChooseDealershipTitle:
					return "popupChooseDealershipTitle"
			case .iAmSure:
					return "iAmSure"
			case .viewSignupPasswordRequireLetter:
					return "viewSignupPasswordRequireLetter"
			case .permissionsLocationDeniedMessage:
					return "permissionsLocationDeniedMessage"
			case .notificationBatteryWarningText:
					return "notificationBatteryWarningText"
			case .popupAlreadyStartedDrivingMessage:
					return "popupAlreadyStartedDrivingMessage"
			case .yes:
					return "yes"
			case .returnToDealership:
					return "returnToDealership"
			case .pickupColon:
					return "pickupColon"
			case .settings:
					return "settings"
			case .notificationForegroundServiceTextDriveLoanerToDealership:
					return "notificationForegroundServiceTextDriveLoanerToDealership"
			case .repairOrderColon:
					return "repairOrderColon"
			case .errorRequestNotCancelable:
					return "errorRequestNotCancelable"
			case .viewEmailBody:
					return "viewEmailBody"
			case .errorInvalidPhoneVerificationCode:
					return "errorInvalidPhoneVerificationCode"
			case .popupTooFarFromDealershipPositive:
					return "popupTooFarFromDealershipPositive"
			case .helpICantUpdateMyPhone:
					return "helpICantUpdateMyPhone"
			case .signout:
					return "signout"
			case .errorForcedUpgradeTitle:
					return "errorForcedUpgradeTitle"
			case .remove:
					return "remove"
			case .viewStartRequestSwipeButtonTitle:
					return "viewStartRequestSwipeButtonTitle"
			case .errorInvalidEmail:
					return "errorInvalidEmail"
			case .confirmNewPassword:
					return "confirmNewPassword"
			case .viewInspectLoanerOverlayInfo:
					return "viewInspectLoanerOverlayInfo"
			case .viewInspectLoanerMinPhotosWarning:
					return "viewInspectLoanerMinPhotosWarning"
			case .viewScheduleEmpty:
					return "viewScheduleEmpty"
			case .viewRecordLoanerMileageDropoffInfoNext:
					return "viewRecordLoanerMileageDropoffInfoNext"
			case .viewArrivedatCustomer:
					return "viewArrivedatCustomer"
			case .popupAlreadyStartedDrivingTitle:
					return "popupAlreadyStartedDrivingTitle"
			case .errorUserDisabled:
					return "errorUserDisabled"
			case .notAvailable:
					return "notAvailable"
			case .viewInspectDocumentsMinPhotoWarning:
					return "viewInspectDocumentsMinPhotoWarning"
			case .viewRetrieveVehicleCustomerSwipeTitle:
					return "viewRetrieveVehicleCustomerSwipeTitle"
			case .help:
					return "help"
			case .updateNow:
					return "updateNow"
			case .viewStartRequestRetrieveForms:
					return "viewStartRequestRetrieveForms"
			case .errorSoftUpgradeTitle:
					return "errorSoftUpgradeTitle"
			case .yourAccount:
					return "yourAccount"
			case .viewContactText:
					return "viewContactText"
			case .cancel:
					return "cancel"
			case .errorInvalidVerificationCode:
					return "errorInvalidVerificationCode"
			case .errorInvalidPhoneNumber:
					return "errorInvalidPhoneNumber"
			case .notificationForegroundServiceTextDriverInspectLoaner:
					return "notificationForegroundServiceTextDriverInspectLoaner"
			case .popupForgotPasswordMessage:
					return "popupForgotPasswordMessage"
			case .notificationForegroundServiceTextDriverVehicleToCustomer:
					return "notificationForegroundServiceTextDriverVehicleToCustomer"
			case .viewContactCall:
					return "viewContactCall"
			case .exchangeKey:
					return "exchangeKey"
			case .model:
					return "model"
			case .recentMileageColon:
					return "recentMileageColon"
			case .errorInvalidFirstName:
					return "errorInvalidFirstName"
			case .errorLocationOutOfDropoffArea:
					return "errorLocationOutOfDropoffArea"
			case .popupSelectTimeSlotUnavailableCallDealership:
					return "popupSelectTimeSlotUnavailableCallDealership"
			case .new:
					return "new"
			case .viewHelpOptionDetailEmailVolvo:
					return "viewHelpOptionDetailEmailVolvo"
			case .viewScheduleServiceTypeOtherUnknown:
					return "viewScheduleServiceTypeOtherUnknown"
			case .number2:
					return "number2"
			case .permissionsCameraDeniedTitle:
					return "permissionsCameraDeniedTitle"
			case .viewIntroFooterSignin:
					return "viewIntroFooterSignin"
			case .errorOffline:
					return "errorOffline"
			case .viewProfileChangePasswordTemp:
					return "viewProfileChangePasswordTemp"
			case .errorFaceDetectionMessage:
					return "errorFaceDetectionMessage"
			case .phoneNumber:
					return "phoneNumber"
			case .permissionsCameraDeniedMessage:
					return "permissionsCameraDeniedMessage"
			case .popupTooFarFromDealershipTitle:
					return "popupTooFarFromDealershipTitle"
			case .number5:
					return "number5"
			case .viewSigninPasswordShort:
					return "viewSigninPasswordShort"
			case .viewTosContentTermsOfServiceTitle:
					return "viewTosContentTermsOfServiceTitle"
			case .viewSignupPasswordRequireNumber:
					return "viewSignupPasswordRequireNumber"
			case .viewReceiveVehicle:
					return "viewReceiveVehicle"
			case .viewLogoTitle:
					return "viewLogoTitle"
			case .back:
					return "back"
			case .requestCanceled:
					return "requestCanceled"
			case .errorAmbiguousCustomerUpsert:
					return "errorAmbiguousCustomerUpsert"
			case .notificationForegroundServiceTextGetToDealership:
					return "notificationForegroundServiceTextGetToDealership"
			case .viewDrivetoArriveatCustomer:
					return "viewDrivetoArriveatCustomer"
			case .notificationForegroundServiceTextDriverInspectDocuments:
					return "notificationForegroundServiceTextDriverInspectDocuments"
			case .popupAddNewLocationLabel:
					return "popupAddNewLocationLabel"
			case .add:
					return "add"
			case .deliveryColon:
					return "deliveryColon"
			case .viewArrivedat:
					return "viewArrivedat"
			case .viewGettoCustomer:
					return "viewGettoCustomer"
			case .viewDrawerNavigationPreferenceGoogle:
					return "viewDrawerNavigationPreferenceGoogle"
			case .viewPhoneAddLabel:
					return "viewPhoneAddLabel"
			case .errorLocationOutOfPickupArea:
					return "errorLocationOutOfPickupArea"
			case .popupTooFarFromDealershipMessage:
					return "popupTooFarFromDealershipMessage"
			case .number9:
					return "number9"
			case .viewSoftwareLicences:
					return "viewSoftwareLicences"
			case .viewHelpOptionDetailCallDealer:
					return "viewHelpOptionDetailCallDealer"
			case .notificationForegroundServiceTextDriverInspectCustomer:
					return "notificationForegroundServiceTextDriverInspectCustomer"
			case .viewPhoneVerificationLabel:
					return "viewPhoneVerificationLabel"
			case .notificationForegroundServiceTextDriverMeetWithCustomer:
					return "notificationForegroundServiceTextDriverMeetWithCustomer"
			case .viewRetrieveVehicleLoaner:
					return "viewRetrieveVehicleLoaner"
			case .viewHelpOptionDetailEmailDealer:
					return "viewHelpOptionDetailEmailDealer"
			case .viewRetrieveVehicleLoanerSwipeTitle:
					return "viewRetrieveVehicleLoanerSwipeTitle"
			case .toastSettingsLocationDisabled:
					return "toastSettingsLocationDisabled"
			case .viewDrawerProfileOptionsChangePassword:
					return "viewDrawerProfileOptionsChangePassword"
			case .notificationForegroundServiceTextDriverLoanerToCustomer:
					return "notificationForegroundServiceTextDriverLoanerToCustomer"
			case .viewDrivetoSwipeButtonTitle:
					return "viewDrivetoSwipeButtonTitle"
			case .inspectVehicle:
					return "inspectVehicle"
			case .viewInspectCustomerMinPhotosWarning:
					return "viewInspectCustomerMinPhotosWarning"
			case .viewStartRequestDropoff:
					return "viewStartRequestDropoff"
			case .popupDeviceChangeTitle:
					return "popupDeviceChangeTitle"
			case .viewScheduleStateRefreshButton:
					return "viewScheduleStateRefreshButton"
			case .serviceColon:
					return "serviceColon"
			case .viewScheduleListItemTypePickup:
					return "viewScheduleListItemTypePickup"
			case .viewTosContentPrivacyPolicyTitle:
					return "viewTosContentPrivacyPolicyTitle"
			case .vehicleMake:
					return "vehicleMake"
			case .errorPasswordNotMatch:
					return "errorPasswordNotMatch"
			case .viewGettoDealershipSwipeButtonTitle:
					return "viewGettoDealershipSwipeButtonTitle"
			case .viewIntro:
					return "viewIntro"
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
