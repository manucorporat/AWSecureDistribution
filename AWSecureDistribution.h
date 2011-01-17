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

#import <IOKit/IOKitLib.h>

#define AW_CONCAT_AGAIN(x, y) x ## y
#define AW_CONCAT(x,y) AW_CONCAT_AGAIN(x,y)

/******** IMPORTANT *********/
// Change this key to improved the security
#define KAW_SECURE_KEY GFYCBNSA934



extern BOOL AW_CONCAT(awsc, KAW_SECURE_KEY)(const char **devices,  const unsigned int nuDevices);
#define awSecureCheck(__DEVICES__, __NUDEVICES__) AW_CONCAT(awsc, KAW_SECURE_KEY)(__DEVICES__,  __NUDEVICES__)

/* This is the most secure way
 You should store the accepted UUIDs under a MD5 encryption
 Generate MD5 keys with this tool:
 http://www.miraclesalad.com/webtools/md5.php
 */
 
extern BOOL AW_CONCAT(awscMd5, KAW_SECURE_KEY)(const char **devices,  const unsigned int nuDevices);
#define awSecureCheckMD5(__DEVICES__, __NUDEVICES__) AW_CONCAT(awscMd5, KAW_SECURE_KEY)(__DEVICES__,  __NUDEVICES__)

