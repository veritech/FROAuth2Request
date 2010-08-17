//
//  FROAuth2Client.h
//
//  Created by Jonathan Dalrymple on 17/08/2010.
//  Copyright 2010 Float:Right. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FROAuth2Client : NSObject {
	NSString	*_key;
	NSString	*_secret;
	NSURL		*_redirectURL;
}

@property (readonly,nonatomic) NSString *key;
@property (readonly,nonatomic) NSString *secret;
@property (readonly,nonatomic) NSURL	*redirectURL;

-(id) initWithKey:(NSString*) aKey secret:(NSString*) aSecret redirect:(NSURL*) aURL;
-(NSURL*) accessRequestURL:(NSURL*) aRequestURL;


@end
