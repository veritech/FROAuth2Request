//
//  FROAuth2Client.h
//
//  Created by Jonathan Dalrymple on 16/08/2010.
//  Copyright 2010 Float:Right. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"

@interface FROAuth2Token : NSObject {
	NSString	*_token;
	NSString	*_refreshToken;
	NSDate		*_expiry;
	BOOL		_readOnly;
}

@property (nonatomic,readonly) NSString *tokenString;

@property (nonatomic,readonly) NSString *refreshToken;

@property (nonatomic,readonly) NSDate *expiry;

@property (nonatomic,readonly, getter=isReadOnly) BOOL readOnly;

-(id) initWithHTTPResponse:(NSString*) aString;

-(BOOL) isValid;

@end
