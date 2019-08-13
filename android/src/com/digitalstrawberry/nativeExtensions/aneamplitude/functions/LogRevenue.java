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

import com.adobe.fre.*;
import com.amplitude.api.Amplitude;
import com.amplitude.api.Revenue;
import org.json.JSONException;
import org.json.JSONObject;

public class LogRevenue implements FREFunction
{
	@Override
	public FREObject call( FREContext context, FREObject[] args )
	{
		try
		{
			String productIdentifier = args[0].getAsString();
			int quantity = args[1].getAsInt();
			double price = args[2].getAsDouble();
            String receipt = getStringArg(args[3]);
            String receiptSignature = getStringArg(args[4]);
            String revenueType = getStringArg(args[5]);
            JSONObject eventProperties = getJsonArg(args[6]);

            Revenue revenue = new Revenue();
			revenue.setProductId(productIdentifier);
			revenue.setQuantity(quantity);
			revenue.setPrice(price);
			if(receipt != null && !receipt.isEmpty())
			{
				revenue.setReceipt(receipt, receiptSignature);
			}
            if(revenueType != null)
            {
                revenue.setRevenueType(revenueType);
            }
            if(eventProperties != null)
            {
                revenue.setEventProperties(eventProperties);
            }

            Amplitude.getInstance().logRevenueV2(revenue);
		}
		catch(Exception e)
		{
			e.printStackTrace();
			return null;
		}
		
		return null;
	}

    private String getStringArg( FREObject object ) throws FREInvalidObjectException, FRETypeMismatchException, FREWrongThreadException
    {
        if( object == null )
        {
            return null;
        }
        return object.getAsString();
    }

    private JSONObject getJsonArg(FREObject object ) throws FREInvalidObjectException, FRETypeMismatchException, FREWrongThreadException, JSONException
    {
        if( object == null )
        {
            return null;
        }
        String jsonString = object.getAsString();
        return new JSONObject(jsonString);
    }
}