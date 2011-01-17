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
#define KAWSECURE_MD5 32

#import <string.h>
#import "md5/md5.h"
#import "AWSecureDistribution.h"

const char* AW_CONCAT(awsu, KAW_SECURE_KEY)()
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


BOOL AW_CONCAT(awsc, KAW_SECURE_KEY)(const char **devices, const unsigned int nuDevices)
{
	const char *uuid = AW_CONCAT(awsu, KAW_SECURE_KEY)();
	
	if(uuid != NULL)
	{
		if(strlen(uuid) == KAWSECURE_UUID_N_CHARS)
		{
			for(int i = 0; i<nuDevices; i++)
			{
				if(devices[i] != NULL)
				{
					if(strlen(devices[i]) == KAWSECURE_UUID_N_CHARS)
					{
						if(strcmp(uuid, devices[i]) == 0)
							return YES;
								
					}
				}else break;
			}
		}
	}
	return NO;
}


BOOL AW_CONCAT(awscMd5, KAW_SECURE_KEY)(const char **devices, const unsigned int nuDevices)
{
	const char *uuid = AW_CONCAT(awsu, KAW_SECURE_KEY)();
	
	if(uuid != NULL)
	{
		if(strlen(uuid) == KAWSECURE_UUID_N_CHARS)
		{
			// Encrypt local UUID
			md5_state_t md5State;
			md5_byte_t digest[16];

			md5_init(&md5State);
			md5_append(&md5State, (const md5_byte_t *)uuid, KAWSECURE_UUID_N_CHARS);
			md5_finish(&md5State, digest);
			
			// Convert to HEX
			char uuidMD5[KAWSECURE_MD5 + 1];
			for (int i = 0; i < 16; i++)
				sprintf(uuidMD5 + i * 2, "%02x", digest[i]);
					
			// Compare
			for(int i = 0; i<nuDevices; i++)
			{
				if(devices[i] != NULL)
				{
					if(strlen(devices[i]) == KAWSECURE_MD5)
					{
						if(strcmp(uuidMD5, devices[i]) == 0)
							return YES;
						
					}
				}else break;
			}
		}
	}
	return NO;
}
