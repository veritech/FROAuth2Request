//
//  FROAuth2Client.m
//
//  Created by Jonathan Dalrymple on 16/08/2010.
//  Copyright 2010 Float:Right. All rights reserved.
//

#import "FROAuth2Token.h"

@interface FROAuth2Token(private)

-(void) restore;

@end


@implementation FROAuth2Token

@synthesize tokenString = _token;
@synthesize refreshToken = _refreshToken;

@synthesize expiry = _expiry;

@synthesize readOnly = _readOnly;

+(id) tokenDefault{
	FROAuth2Token	*token;
	
	token = [[[FROAuth2Token alloc] init] autorelease];
	
	[token restore];
	DebugLog(@"Restored Token %@",token);
	if( [token tokenString] ){
		return token;
	}
	else{
		DebugLog(@"Bad token");
		return nil;
	}
}


-(id) init{
	
	if( (self =[super init]) ){
		
		 _token = nil;
		 
		 _refreshToken = nil;
		 
		 _expiry = [NSDate date];
		 
		 _readOnly = YES;
	}
	
	return self;
}

//Create a token with the given response
-(id) initWithHTTPResponse:(NSString*) aString{
	
	if( (self = [self init]) ){
		
		NSDictionary	*kvPairs;
		
		kvPairs = [aString JSONValue];
		
		_token = [[kvPairs objectForKey:@"access_token"] retain];
		
		_refreshToken = [[kvPairs objectForKey:@"refresh_token"] retain];
		
		_expiry = [NSDate dateWithTimeIntervalSinceNow:[[kvPairs objectForKey:@"expires_in"] integerValue]];
		
		//If there is scope parameter
		if([kvPairs objectForKey:@"scope"]){
			if( [[kvPairs objectForKey:@"scope"] isEqualToString:@"read-write"] ){
				_readOnly = NO;
			}
		}
	}
	
	return self;
}

//Is a token valid
-(BOOL) isValid{
	
	if( [[NSDate date] compare:[self expiry]] == NSOrderedAscending ){
		return YES;
	}
	else{
		return NO;
	}
	
}



//Private methods
-(NSString*) defaultsPrefix{
	return @"default";
}

-(NSString*) keyForAttribute:(NSString*) aString{
	return [NSString stringWithFormat:@"OAuth.%@.%@",[self defaultsPrefix],aString];
}

-(void) save{
	
	NSUserDefaults	*defaults;
	
	defaults = [NSUserDefaults standardUserDefaults];
	
	//Readonly
	[defaults setBool:[self isReadOnly] 
			   forKey:[self keyForAttribute:@"readOnly"]
	];
	
	//Access token
	[defaults setObject:[self tokenString] 
				 forKey:[self keyForAttribute:@"tokenString"]
	];
	
	//Refresh token
	[defaults setObject:[self refreshToken] 
				 forKey:[self keyForAttribute:@"refreshToken"]
	 ];
	
	//Expiry Date
	[defaults setObject:[self expiry] 
				 forKey:[self keyForAttribute:@"expiry"]
	 ];
	
	//flush to disk
	[defaults synchronize];
}

-(void) restore{
	NSUserDefaults	*defaults;
	
	defaults = [NSUserDefaults standardUserDefaults];
	
	_readOnly = [defaults boolForKey:[self keyForAttribute:@"readOnly"]];
	
	_token = [[defaults stringForKey:[self keyForAttribute:@"tokenString"]] retain];
 
	_refreshToken = [[defaults stringForKey:[self keyForAttribute:@"refreshToken"]] retain];
	
	_expiry = [[defaults objectForKey:[self keyForAttribute:@"expiry"]] retain];
}

-(NSString*) description{
	
	return [NSString stringWithFormat:@"%@\r\ntoken = %@\r\nexpiry = %@",[super description], _token, _expiry];
}

-(void) dealloc{
	
	[_token release];
	
	[_refreshToken release];
	
	//Expiry is autorelease in all situations
	//[_expiry release];
	
	_token = nil;
	
	_refreshToken = nil;
	
	_expiry = nil;
	
	[super dealloc];
}

@end
