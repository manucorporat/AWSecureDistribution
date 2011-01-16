/*
 * AWSecureDistribution: http://forzefield.com
 *
 * Copyright (c) 2010 ForzeField Studios S.L.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "AWSecureDistribution.h"

@implementation AWSecureDistribution

+ (NSString*) getSystemSerialNumber
{
	NSString *serialNumber = nil;

	io_service_t platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"));
	if (platformExpert)
	{
		CFTypeRef snCFString = IORegistryEntryCreateCFProperty(platformExpert, CFSTR(kIOPlatformSerialNumberKey), kCFAllocatorDefault, 0);

		if(snCFString)
			serialNumber = [(NSString*)CFXMLCreateStringByUnescapingEntities(NULL, snCFString, NULL) autorelease];

		IOObjectRelease(platformExpert);
	}
	return serialNumber;
}

+ (BOOL) checkAccepted:(NSArray*)availableSystems
{
	NSString *serial = [AWSecureDistribution getSystemSerialNumber];
	if(serial==nil)
	{
		NSLog(@"Error getting serial number");
		return NO;
	}
	
	for(NSString *string in availableSystems)
		if([serial isEqualToString:string])
			return YES;
	
	return NO;
}

@end
