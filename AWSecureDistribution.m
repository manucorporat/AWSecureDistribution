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

#define KAWSECURE_UUID_N_CHARS 36
#define SECURE_KEY b1sk6
#import <string.h>

#import "AWSecureDistribution.h"

const char* getHardwareUUID()
{
	io_service_t platformExpert  = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"));
	
	if (!platformExpert)
        return NULL;
	
	const CFTypeRef snCFString = IORegistryEntryCreateCFProperty(platformExpert, CFSTR(kIOPlatformUUIDKey), kCFAllocatorDefault, 0);
	
	if(snCFString)
	{
		const char *serialBuff = CFStringGetCStringPtr(snCFString, kCFStringEncodingMacRoman);
		if(serialBuff)
			return serialBuff;		
		
		CFRelease(snCFString);
	}
	IOObjectRelease(platformExpert);
	return NULL;
}

BOOL awSecureCheckAccepted(char **devices)
{
	const char *serial = getHardwareUUID();
	
	if(serial==NULL)
		return NO;
	
	if(strlen(serial) != KAWSECURE_UUID_N_CHARS)
		return NO;
		
	int i = 0;
	while (YES)
	{
		if(devices[i] == NULL)
			return NO;
	
		if(strcmp(serial, devices[i]) == 0)
			return YES;
		
		i++;
	}
	
	return NO;
}
