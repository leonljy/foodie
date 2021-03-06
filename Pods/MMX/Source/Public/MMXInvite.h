/*
 * Copyright (c) 2015 Magnet Systems, Inc.
 * All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you
 * may not use this file except in compliance with the License. You
 * may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
 * implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

#import <Mantle/Mantle.h>
@class MMXUser;
@class MMXChannel;

@interface MMXInvite : MTLModel

/**
 *  Time the invite was sent
 */
@property (nonatomic, readonly) NSDate *timestamp;

/**
 *  A custom message from the sender
 */
@property (nonatomic, copy, readonly) NSString *comments;

/**
 *  The user that sent the invite
 */
@property (nonatomic, readonly) MMXUser *sender;

/**
 *  The channel the invite is for.
 */
@property (nonatomic, readonly) MMXChannel *channel;

/**
 *  Accept the invite to the channel and start receiving message published to the channel.
 *
 *  @param comments	Optional custom message
 *  @param success	Block called if operation is successful.
 *  @param failure	Block with an NSError with details about the call failure.
 */
- (void)acceptWithComments:(NSString *)comments
                   success:(void (^)(void))success
                   failure:(void (^)(NSError *error))failure;

/**
 *  Decline the invite to the channel.
 *
 *  @param comments	Optional custom message
 *  @param success	Block called if operation is successful.
 *  @param failure	Block with an NSError with details about the call failure.
 */
- (void)declineWithComments:(NSString *)comments
                    success:(void (^)(void))success
                    failure:(void (^)(NSError *error))failure;


@end
