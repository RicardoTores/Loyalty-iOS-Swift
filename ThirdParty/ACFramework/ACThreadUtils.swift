//
//  ACThreadUtils.swift
//  Wrapps "system queue" management functions using the constants required for its functionality.
//
//  Example:
//     GlobalMainQueue is equivalent to call dispatch_get_main_queue()
//
//  Created by Alex on 13/9/15.
//  Copyright (c) 2015 Colectivo Coffee Roasters Inc. All rights reserved.
//

import Foundation

/*!
   @var GlobalMainQueue
   @discussion raps a call to dispatch_get_main_queue() without params
*/
public var GlobalMainQueue: dispatch_queue_t {
    return dispatch_get_main_queue()
}

/*!
   @var GlobalUserInteractiveQueue
   @discussion Wraps a call to dispatch_get_global_queue() with QOS_CLASS_USER_INTERACTIVE
*/
public var GlobalUserInteractiveQueue: dispatch_queue_t {
    return dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.rawValue), 0)
}

/*!
   @var GlobalUserInitiatedQueue
   @discussion Wraps a call to dispatch_get_global_queue() with QOS_CLASS_USER_INITIATED
*/
public var GlobalUserInitiatedQueue: dispatch_queue_t {
    return dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)
}

/*!
   @var GlobalUtilityQueue
   @discussion Wraps a call to dispatch_get_global_queue() with QOS_CLASS_UTILITY
*/
public var GlobalUtilityQueue: dispatch_queue_t {
    return dispatch_get_global_queue(Int(QOS_CLASS_UTILITY.rawValue), 0)
}


/*!
   @var GlobalBackgroundQueue
   @discussion Wraps a call to dispatch_get_global_queue() with QOS_CLASS_BACKGROUND
*/
public var GlobalBackgroundQueue: dispatch_queue_t {
    return dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.rawValue), 0)
}
