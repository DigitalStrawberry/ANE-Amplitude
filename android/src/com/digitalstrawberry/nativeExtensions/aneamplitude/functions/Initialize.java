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

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.amplitude.api.Amplitude;

public class Initialize implements FREFunction
{
	@Override
	public FREObject call( FREContext context, FREObject[] args )
	{
		String apiKey = "";
		String userId = null;
		boolean autoTrackSession = false;

		try
		{
			apiKey = args[0].getAsString();
            // Get user id if provided
            if(args[1] != null)
            {
                userId = args[1].getAsString();
            }
            // Enable session auto tracking if requested
            autoTrackSession = args[2].getAsBool();
		}
		catch(Exception e)
		{
			e.printStackTrace();
			return null;
        }

        if(userId == null || userId.equals(""))
		{
			Amplitude.getInstance().initialize(context.getActivity().getApplicationContext(), apiKey);
		}
		else
		{
			Amplitude.getInstance().initialize(context.getActivity().getApplicationContext(), apiKey, userId);
		}
        // Session tracking must be enabled after initialization
        if(autoTrackSession)
        {
            Amplitude.getInstance().trackSessionEvents(true);
        }

		
		return null;
	}
}