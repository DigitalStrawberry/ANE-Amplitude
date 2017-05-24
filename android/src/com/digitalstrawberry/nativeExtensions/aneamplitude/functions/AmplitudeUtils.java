/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2017 Digital Strawberry LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

package com.digitalstrawberry.nativeExtensions.aneamplitude.functions;

import org.json.JSONObject;

import com.adobe.fre.FREArray;

public class AmplitudeUtils
{
	
	public static JSONObject GetJSONFromArray(FREArray array)
	{
		JSONObject json = new JSONObject();
		
		try
		{
			int totalElements = (int) (array.getLength() / 2);
			String key, value;
			
			for(int i = 0; i < totalElements; i++)
			{
				key = array.getObjectAt(i * 2).getAsString();
				value = array.getObjectAt((i * 2) + 1).getAsString();
				
				json.putOpt(key, value);
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
			return json;
		}
		
		return json;	
	}
	
}
