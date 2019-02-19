//
//  Analytics+Request.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 2/18/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation

extension AnalyticsEnums {
    
    public static func screen(for task: Task, request: Request) -> AnalyticsEnums.Name.Screen {
    
        // review Service
        if task == .startRequest || task == .schedule  {
            if request.isPickup {
                return .pickupReviewService
            }
            return .deliveryReviewService
        }
        
        // drive to // Get To
        else if task == .driveLoanerVehicleToCustomer {
            return .pickupDriveToCustomer
        } else if task == .driveVehicleToCustomer {
            return .deliveryDriveToCustomer
        } else if task == .driveVehicleToDealership {
            return .pickupReturnToDealership
        } else if task == .driveLoanerVehicleToDealership {
            return .deliveryReturnToDealership
        } else if task == .getToCustomer {
            return .pickupGetToCustomer
        } else if task == .getToDealership {
            return .deliveryGetToDealership
        }
        // Exchange Keys
        else if task == .exchangeKeys {
            if request.isPickup {
                return .pickupExchangeKey
            }
            return .deliveryExchangeKey
        }
        
        // Inspections
        else if task == .inspectDocuments {
            return .pickupPhotoDocuments
        } else if task == .inspectVehicle {
            if request.isPickup {
                return .pickupPhotoCustomerVehicle
            }
            return .deliveryPhotoCustomerVehicle
        } else if task == .inspectLoanerVehicle {
            if request.isPickup {
                return .pickupPhotoLoaner
            }
            return .deliveryPhotoLoaner
        } else if task == .inspectNotes {
            return .pickupVehicleNotes
        }
        
        // Meet
        else if task == .meetWithCustomer {
            if request.isPickup {
                return .pickupMeetCustomer
            }
            return .deliveryMeetCustomer
        }
        
        // Meet
        else if task == .receiveLoanerVehicle {
            return .deliveryReceiveLoaner
        }
        else if task == .recordLoanerMileage {
            if request.isPickup {
                return .pickupLoanerMileage
            }
            return .deliveryLoanerMileage
        }
        // Pre Pickup
        else if task == .retrieveForms {
            return .pickupGetPaperwork
        } else if task == .retrieveLoanerVehicleFromDealership {
            return .pickupRetrieveLoaner
        }
            
        else if task == .retrieveVehicleFromDealership {
            return .deliveryRetrieveCustVehicle
        }
        
        // Unknown
        else  {
            if request.isPickup {
                return .pickupUnknown
            }
            return .deliveryUnknown
        }
        
    }
    
}
