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
import com.amplitude.api.Revenue;

public class LogRevenue implements FREFunction
{
	@Override
	public FREObject call( FREContext context, FREObject[] args )
	{
		String receipt = null;
		String receiptSignature = null;
		Revenue revenue = new Revenue();
		
		try
		{
			String productIdentifier = args[0].getAsString();
			int quantity = args[1].getAsInt();
			double price = args[2].getAsDouble();
			
			if(args.length > 3)
			{
				receipt = args[3].getAsString();
			}
			if(args.length > 4)
			{
				receiptSignature = args[4].getAsString();
			}

			revenue.setProductId(productIdentifier);
			revenue.setQuantity(quantity);
			revenue.setPrice(price);
			if(receipt != null && !receipt.isEmpty())
			{
				revenue.setReceipt(receipt, receiptSignature);
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
			return null;
		}

		Amplitude.getInstance().logRevenueV2(revenue);
		
		return null;
	}
}