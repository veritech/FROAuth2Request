//
//  FROAuth2Client.m
//
//  Created by Jonathan Dalrymple on 17/08/2010.
//  Copyright 2010 Float:Right. All rights reserved.
//

#import "FROAuth2Client.h"


@implementation FROAuth2Client

@synthesize key = _key;
@synthesize secret = _secret;
@synthesize redirectURL = _redirectURL;

-(id) initWithKey:(NSString*) aKey secret:(NSString*) aSecret redirect:(NSURL*) aURL{
	
	if( (self =[super init] ) ){
		
		_key = [aKey retain];
		_secret = [aSecret retain];
		_redirectURL = [aURL retain];
	}
	
	return self;
}

//Clent authorisation url
-(NSURL*) accessRequestURL:(NSURL*) aRequestURL{
	
	return [NSURL URLWithString:
			[NSString stringWithFormat:
				@"%@?redirect_uri=%@&client_id=%@",
				aRequestURL,
				[self redirectURL], 
				[self key]
			]
	];
}

-(void) dealloc{
	
	[_key release];
	[_secret release];
	[_redirectURL release];
	
	_key = nil;
	_secret = nil;
	_redirectURL = nil;
	
	[super dealloc];
	
}

@end
