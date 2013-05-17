// -----------------------------------------------------------------
// Provides mutliple tools that makes you live as a APEX developer easier
//
// @Name	MapTools
// @Author	Anton Zeef <azeef@deloitte.nl>
// @Created	2013-05-14
// -----------------------------------------------------------------
/**
 * Tools for converting from/to Internation Bank Account Numbers (IBAN, for short).
 *
 * IBAN numbers have the format XXYY ZZZZZZZZZZ where:
 * - XX is the two-character 
 * - YY is a two-digit control sequence
 * - ZZZZZZZZZZ is the account identifier, which has a different format for each country
 * 		- Dutch account identifiers are built up of 14 characters, the first four making up the bankcode and the last 10 are for the accountnumber 
 *
 * See http://en.wikipedia.org/wiki/International_Bank_Account_Number 
 */
public class IBanTools {

	/** Indicates an error with checking/converting to/from iban numbers */
	public class IBANException extends Exception {}

	/**
	 * Converts a Dutch bank account number to an IBAN.
	 *
	 * This method tries to make sure only valid Dutch bank account numbers are converted by performing the Elf-test. 
	 */
	public static String toIBAN( String dutchBankAccountNr, String bankCode ) {
		// first check if it's non-empty, all-digits and reasonably sized
		if( String.isBlank( dutchBankAccountNr ) || !dutchBankAccountNr.isNumeric() ) {
			throw new IBANException( 'Invalid Dutch bankaccount number: \'' + dutchBankAccountNr + '\'' );
		}
		// and check if the bankcode is valid
		if( String.isBlank( bankCode) || bankCode.length() != 4 ) {
			throw new IBANException( 'Invalid bankcode: \'' + bankCode + '\'' );
		}
		
		// check if it's a valid dutch bankaccount number
		if( dutchBankAccountNr.length() > 10 || ( dutchBankAccountNr.length() >= 9 && !compliesToElfTest( dutchBankAccountNr ) ) ) {
			throw new IBANException( 'Invalid Dutch bankaccount number: \'' + dutchBankAccountNr + '\'' );
		} /*else {
			former 'postbank' bankaccountnr, number of digits is between 1 and 8 (inclusive), no check possible...
		}
		*/
		// calculate the control digits, based on the basic bank account number and the bank code
		// basic bank account is the bankcode with the 10-digit bank account number for Dutch bank account numbers
		String bban = bankCode + prefixWithZeroes( dutchBankAccountNr, 10 );
		String controlDigits = generateControlDigits( bban, 'NL' );
		String iban = 'NL' + controlDigits + bban;
		return iban;
	}

	/**
	 * Checks if the passed bank account number complies to the Dutch Elf-test.
	 *
	 * This test works on 10 or 9 digit numbers by giving the digits a positionnumber starting at 1 and increasing the number from right to left. The controlnumber is then calculated by multiplying each digit with it's position number and summing.
	 * The account number then passed the Elf-test if the remainder of dividing the controlnumber by 11 is zero.
	 *
	 * Note: only works if the passed account number is fully numeric.
	 */
	public static Boolean compliesToElfTest( String bankAccountNumber ) {
		if( bankAccountNumber.length() > 10 || bankAccountNumber.length() < 9 ) {
			return false;
		}
		Integer tester = 0;
		String sorted = bankAccountNumber.reverse();
		for( Integer i = 0; i < sorted.length(); i++ ) {
			tester += (i + 1) * Integer.valueOf( sorted.substring(i, i + 1 ) );
		}
		return Math.mod( tester, 11 ) == 0;
	}

	/** Pads the string with zeroes until the maxLength is reached */
	public static String prefixWithZeroes( String s, Integer maxLength ) {
		Integer numPadZeroes = maxLength - s.length();
		if( numPadZeroes <= 0 ) {
			return s;
		}
		return '0'.repeat( numPadZeroes ) + s;
	}

	/** 
	 * Generates the IBAN control digits based on the basic bank account number (bban) and two-character land code
	 *
	 * IBAN control digits are calculated by 
	 * - first, placing both the {@code landCode} and the '00' behind the {@code bban}
	 * - then, replacing all non-digits in the resulting string with their lettercode according to the substitution 'A' -> 10, ..., 'Z' -> 35
	 * - next, taking the modulus of the resulting number with 97
	 * - lastly, substracting the result from 98, adding a leading zero if that makes the result less than 10
	 */
	public static String generateControlDigits( String bban, String landCode ) {
		// generate the control string
		String controlS = '';
		// - replace all characters in the iban with their base-36 equivalent
		for( Integer i = 0; i < bban.length(); i++ ) {
			String s = bban.substring( i, i + 1 );
			if( s.isNumeric() ) {
				controlS += s;
			} else if( s.isAlpha() && s.isAsciiPrintable() ) {
				controlS += letterCodes.get( s.toUpperCase() );
			} else {
				throw new IBANException( 'character at index ' + i + ' of basic bank account number \'' + bban + '\' is not ascii-alphanumeric' );
			}
		}
		// - replace all characters in the landcode with their base-36 equivalent
		for( Integer i = 0; i < landCode.length(); i++ ) {
			String s = landCode.substring( i, i + 1 );
			if( s.isAlpha() && s.isAsciiPrintable() ) {
				controlS += letterCodes.get( s.toUpperCase() );
			} else {
				throw new IBANException( 'character at index ' + i + ' of landcode \'' + landCode + '\' is not an ascii-alpha' );
			}
		}
		// add the final '00'
		controlS += '00';
		/*
		// sanity check: retrieved control-string should be numeric
		if( !controlS.isNumeric() ) {
			throw new IBANException( 'controlstring \'' + controlS + '\'is not numeric' );
		}*/
		// now compute the remainder
		Integer startI = 0;
		Integer endI = Math.min( 9, controlS.length() );
		String temp = controlS.subString( startI, endI );
		String controlDigits = String.valueOf( Math.mod( Integer.valueOf( temp ), 97 ) );
		while( endI < controlS.length() ) {
			startI = endI;
			endI = Math.min( endI + 7, controlS.length() );
			temp = controlDigits + controlS.subString( startI, endI );
			controlDigits = String.valueOf( Math.mod( Integer.valueOf( temp ), 97 ) );
		}
		return prefixWithZeroes( String.valueOf( 98 - Integer.valueOf( controlDigits ) ), 2 );
	}

	/**
	 * Checks the passed IBAN.
	 *
	 * For now, only Dutch IBANs can be checked. Those are comprised of 18 characters, starting with NL, followed by two check digits, then the 10-digit bank-accountnumber.
	 */
	public static Boolean checkIBAN( String iban ) {
		// definitively not a valid iban if blank, oversized or undersized 
		if( String.isBlank( iban) || iban.length() > 34 || iban.length() < 5 ) {
			return false;
		}
		// first two characters should be the landcode
		String landCode = iban.substring( 0, 2 ).toUpperCase();
		//system.debug( '### landcode = ' + landCode );
		// next two characters are the control digits
		String controlS = iban.substring( 2, 4 );
		//system.debug( '### controlS = ' + controlS );
		if( !controlS.isNumeric() ) {
			return false;
		}
		// basic bank account number starts at index 4
		String bban = iban.substring( 4 );
		//system.debug( '### bban = ' + bban );
		if( landCode == 'NL' ) {
			if( iban.length() != 18 ) {
				return false;
			}
			String controlDigits = generateControlDigits( bban, 'NL' );
			return controlDigits == controlS;
		} else {
			return false;
		}
	}
	
	public static List<String> allLetters {
		get {
			if( allLetters == null ) {
				allLetters = new String[] { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'U', 'V', 'W', 'X', 'Y', 'Z' };
			}
			return allLetters;
		} set;
	}

	public static Map<String, String> letterCodes {
		get {
			if( letterCodes == null ) {
				letterCodes = new Map<String, String>();
				Integer start = 10;
				List<String> letters = allLetters;
				for( Integer i = 0; i < letters.size(); i++ ) {
					letterCodes.put( letters.get( i ), String.valueOf( start + i ) );
				}
			}
			return letterCodes;
		} set;
	}
}