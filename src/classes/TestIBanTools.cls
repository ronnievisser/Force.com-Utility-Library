// -----------------------------------------------------------------
// Provides mutliple tools that makes you live as a APEX developer easier
//
// @Name	MapTools
// @Author	Anton Zeef <azeef@deloitte.nl>
// @Created	2013-05-14
// -----------------------------------------------------------------
@isTest
private class TestIBanTools {

	/** Tests the toIBAN method */
	static testMethod void testToIBAN() {
		
		String dutchBankAccountNr = null;
		String bankCode = null;
		String iban = null;
		
		boolean failed = false;
		
		// given
		// - an empty bank accountnr
		dutchBankAccountNr = null;
		try {
			// when
			// - we convert to iban
			iban = IBANTools.toIBAN( dutchBankAccountNr, bankCode );
			// then
			// - we expect an exception
			failed = true;
		} catch ( IBANTools.IBANException e ) {
			failed = false;
		}
		system.assert( failed == false );
		
		// given
		// - a non-numeric bank accountnr
		dutchBankAccountNr = 'Sd500';
		try {
			// when
			// - we convert to iban
			iban = IBANTools.toIBAN( dutchBankAccountNr, bankCode );
			// then
			// - we expect an exception
			failed = true;
		} catch ( IBANTools.IBANException e ) {
			failed = false;
		}
		system.assert( failed == false );
		
		// given
		// - a blank bankcode
		bankCode = null;
		// - with a bank accountnr that looks valid
		dutchBankAccountNr = '500';
		try {
			// when
			// - we convert to iban
			iban = IBANTools.toIBAN( dutchBankAccountNr, bankCode );
			// then
			// - we expect an exception
			failed = true;
		} catch ( IBANTools.IBANException e ) {
			failed = false;
		}
		system.assert( failed == false );
		
		// given
		// - an invalid length bankcode
		bankCode = 'INGB2';
		try {
			// when
			// - we convert to iban
			iban = IBANTools.toIBAN( dutchBankAccountNr, bankCode );
			// then
			// - we expect an exception
			failed = true;
		} catch ( IBANTools.IBANException e ) {
			failed = false;
		}
		system.assert( failed == false );
		
		// given
		// - an invalid sized bank account nr
		dutchBankAccountNr = '12345678901';
		// - with a valid bankcode
		bankCode = 'INGB';
		try {
			// when
			// - we convert to iban
			iban = IBANTools.toIBAN( dutchBankAccountNr, bankCode );
			// then
			// - we expect an exception
			failed = true;
		} catch ( IBANTools.IBANException e ) {
			failed = false;
		}
		system.assert( failed == false );
		
		// given
		// - a bank account nr that doesn't comply to the elf-test
		dutchBankAccountNr = '1234567890';
		// - with a valid bankcode
		bankCode = 'INGB';
		try {
			// when
			// - we convert to iban
			iban = IBANTools.toIBAN( dutchBankAccountNr, bankCode );
			// then
			// - we expect an exception
			failed = true;
		} catch ( IBANTools.IBANException e ) {
			failed = false;
		}
		system.assert( failed == false );

		// given
		// - a bank account nr that complies to the elf-test
		dutchBankAccountNr = '313086109';
		// - with a valid bankcode
		bankCode = 'RABO';
		String expected = 'NL47RABO0313086109';
		try {
			// when
			// - we convert to iban
			iban = IBANTools.toIBAN( dutchBankAccountNr, bankCode );
			// then
			// - we don't expect an exception
			failed = false;
			// - and the generated iban to be the same as the expected one
			system.assert( expected == iban );
		} catch ( IBANTools.IBANException e ) {
			failed = true;
		}
		system.assert( failed == false );
	}

	/** Tests the compliesToElfTest method */
	static testMethod void testCompliesToElfTest() {
		// account nr with less than 9 digits do not comply
		String accountNr = '12345678';
		Boolean complies = IBANTools.compliesToElfTest( accountNr );
		system.assert( complies == false );

		// account nr with more than 10 digits do not comply
		accountNr = '12345678901';
		complies = IBANTools.compliesToElfTest( accountNr );
		system.assert( complies == false );

		// account nr 313086109 complies
		accountNr = '313086109';
		complies = IBANTools.compliesToElfTest( accountNr );
		system.assert( complies == true );
	}

	/** Tests the prefixWithZeroes method */
	static testMethod void testPrefixWithZeroes() {
		// empty string will lead to all-zeroes
		String s = '';
		Integer maxLength = 5;
		String prefixed = IBANTools.prefixWithZeroes( s, maxLength );
		system.assert( prefixed == '0'.repeat( maxLength ) );

		// no zeroes will be prefixed if maxLength has already been reached
		s = '12345';
		prefixed = IBANTools.prefixWithZeroes( s, maxLength );
		system.assert( prefixed == s );

		// zeroes will be prefixed until maxLength has been reached
		s = '12';
		prefixed = IBANTools.prefixWithZeroes( s, maxLength );
		system.assert( prefixed == '00012' );
	}
	

	/** Tests the generateControlDigits method */
	static testMethod void testGenerateControlDigits() {
		String bban = '1234é';
		String landCode = 'ABCD';
		String controlDigits = null;
		
		// a non-printable ascii character in the bban should generate an exception
		boolean failed = false;
		try {
			controlDigits = IBANTools.generateControlDigits( bban, landCode );
			failed = true;
		} catch ( IBANTools.IBANException e ) {
			failed = false;
		}
		system.assert( failed == false );

		bban = 'RABO0313086109';
		// a non-printable ascii character in the landCode should generate an exception
		landcode = 'é';
		failed = false;
		try {
			controlDigits = IBANTools.generateControlDigits( bban, landCode );
			failed = true;
		} catch ( IBANTools.IBANException e ) {
			failed = false;
		}
		system.assert( failed == false );

		// valid bban and landcode should lead to correct control digits
		landCode = 'NL';
		controlDigits = IBANTools.generateControlDigits( bban, landCode );
		system.assert( controlDigits == '47' );
	}

	/** Tests the checkIBAN method */
	static testMethod void testCheckIBAN() {

		// empty ibans are not valid
		String iban = null;
		boolean check = IBANTools.checkIBAN( iban );
		system.assert( check == false );

		// oversized ibans are not valid
		iban = '0'.repeat(35);
		check = IBANTools.checkIBAN( iban );
		system.assert( check == false );

		// undersized ibans are not valid
		iban = '0'.repeat(4);
		check = IBANTools.checkIBAN( iban );
		system.assert( check == false );

		// non-numeric control digits are not valid
		iban = 'NLXX00';
		check = IBANTools.checkIBAN( iban );
		system.assert( check == false );

		// non-Dutch ibans are not valid
		iban = 'EN0000';
		check = IBANTools.checkIBAN( iban );
		system.assert( check == false );

		// Dutch ibans need to have 18 characters
		iban = 'NL00'.repeat(5);
		check = IBANTools.checkIBAN( iban );
		system.assert( check == false );
		
		// Dutch ibans need to have 18 characters
		iban = 'NL00'.repeat(5);
		check = IBANTools.checkIBAN( iban );
		system.assert( check == false );

		// Valid Dutch iban should pass the test
		iban = 'NL47RABO0313086109';
		check = IBANTools.checkIBAN( iban );
		system.assert( check == true );
	}
}