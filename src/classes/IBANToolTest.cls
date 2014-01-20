@isTest
private class IBANToolTest {

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
			iban = IBANTool.toIBAN( dutchBankAccountNr, bankCode );
			// then
			// - we expect an exception
			failed = true;
		} catch ( IBANTool.IBANException e ) {
			failed = false;
		}
		system.assert( failed == false );
		
		// given
		// - a non-numeric bank accountnr
		dutchBankAccountNr = 'Sd500';
		try {
			// when
			// - we convert to iban
			iban = IBANTool.toIBAN( dutchBankAccountNr, bankCode );
			// then
			// - we expect an exception
			failed = true;
		} catch ( IBANTool.IBANException e ) {
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
			iban = IBANTool.toIBAN( dutchBankAccountNr, bankCode );
			// then
			// - we expect an exception
			failed = true;
		} catch ( IBANTool.IBANException e ) {
			failed = false;
		}
		system.assert( failed == false );
		
		// given
		// - an invalid length bankcode
		bankCode = 'INGB2';
		try {
			// when
			// - we convert to iban
			iban = IBANTool.toIBAN( dutchBankAccountNr, bankCode );
			// then
			// - we expect an exception
			failed = true;
		} catch ( IBANTool.IBANException e ) {
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
			iban = IBANTool.toIBAN( dutchBankAccountNr, bankCode );
			// then
			// - we expect an exception
			failed = true;
		} catch ( IBANTool.IBANException e ) {
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
			iban = IBANTool.toIBAN( dutchBankAccountNr, bankCode );
			// then
			// - we expect an exception
			failed = true;
		} catch ( IBANTool.IBANException e ) {
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
			iban = IBANTool.toIBAN( dutchBankAccountNr, bankCode );
			// then
			// - we don't expect an exception
			failed = false;
			// - and the generated iban to be the same as the expected one
			system.assert( expected == iban );
		} catch ( IBANTool.IBANException e ) {
			failed = true;
		}
		system.assert( failed == false );
	}

	/** Tests the prefixWithZeroes method */
	static testMethod void testPrefixWithZeroes() {
		// empty string will lead to all-zeroes
		String s = '';
		Integer maxLength = 5;
		String prefixed = IBANTool.prefixWithZeroes( s, maxLength );
		system.assert( prefixed == '0'.repeat( maxLength ) );

		// no zeroes will be prefixed if maxLength has already been reached
		s = '12345';
		prefixed = IBANTool.prefixWithZeroes( s, maxLength );
		system.assert( prefixed == s );

		// zeroes will be prefixed until maxLength has been reached
		s = '12';
		prefixed = IBANTool.prefixWithZeroes( s, maxLength );
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
			controlDigits = IBANTool.generateControlDigits( bban, landCode );
			failed = true;
		} catch ( IBANTool.IBANException e ) {
			failed = false;
		}
		system.assert( failed == false );

		bban = 'RABO0313086109';
		// a non-printable ascii character in the landCode should generate an exception
		landcode = 'é';
		failed = false;
		try {
			controlDigits = IBANTool.generateControlDigits( bban, landCode );
			failed = true;
		} catch ( IBANTool.IBANException e ) {
			failed = false;
		}
		system.assert( failed == false );

		// valid bban and landcode should lead to correct control digits
		landCode = 'NL';
		controlDigits = IBANTool.generateControlDigits( bban, landCode );
		system.assert( controlDigits == '47' );
	}

	/** Tests the checkIBAN method */
	static testMethod void testCheckIBAN() {

		// empty ibans are not valid
		String iban = null;
		boolean check = IBANTool.checkIBAN( iban );
		system.assert( check == false );

		// oversized ibans are not valid
		iban = '0'.repeat(35);
		check = IBANTool.checkIBAN( iban );
		system.assert( check == false );

		// undersized ibans are not valid
		iban = '0'.repeat(4);
		check = IBANTool.checkIBAN( iban );
		system.assert( check == false );

		// non-numeric control digits are not valid
		iban = 'NLXX00';
		check = IBANTool.checkIBAN( iban );
		system.assert( check == false );

		// non-Dutch ibans are not valid
		iban = 'EN0000';
		check = IBANTool.checkIBAN( iban );
		system.assert( check == false );

		// Dutch ibans need to have 18 characters
		iban = 'NL00'.repeat(5);
		check = IBANTool.checkIBAN( iban );
		system.assert( check == false );
		
		// Dutch ibans need to have 18 characters
		iban = 'NL00'.repeat(5);
		check = IBANTool.checkIBAN( iban );
		system.assert( check == false );

		// Valid Dutch iban should pass the test
		iban = 'NL47RABO0313086109';
		check = IBANTool.checkIBAN( iban );
		system.assert( check == true );
	}

	/** Tests that all letter-characters are present */
	static testMethod void testAllLetters() {
		Set<String> allLetters = new Set<String>( IBANTool.allLetters );
		system.assert( allLetters.size() == 26 );
		for( String l : allLetters ) {
			system.assert( l.length() == 1 );
			system.assert( l.isAlpha() );
			system.assert( l.isAllUpperCase() );
		}
	}

	/** Tests that ibans can be converted to bic (for Dutch IBANs ) */
	static testMethod void testIbanToBic() {
		IBAN_To_Bic__c raboBic = new IBAN_To_Bic__c( Name='RABO', Bic__c='RABONL2U' );
		insert raboBic;

		Test.startTest();
		String iban = 'NL47RABO0313086109';
		String bic = IBANTool.ibanToBic( iban );
		system.assert( bic == 'RABONL2U' );
		
		// ibans with less than 8 characters lead to null bic
		system.assert( IBANTool.ibanToBic( 'NL00' ) == null );
		
		// ibans with unknown bankcodes lead to null bics
		system.assert( IBANTool.ibanToBic( 'NL00UNKN0000' ) == null );
		
		Test.stopTest();
	}

	/** Tests that dutch bank account numbers are checked correctly */
	static testMethod void checkDutchBankAccountNumber() {
		String bankAccountNr = '313086109';
		// valid dutch bank account nr is valid
		system.assert( IBANTool.checkDutchBankAccountNumber( bankAccountNr ) );
		
		bankAccountNr = '313086101';
		// invalid dutch bank account nr is invalid
		system.assert( !IBANTool.checkDutchBankAccountNumber( bankAccountNr ) );

		bankAccountNr = '313086101';
		// invalid dutch bank account nr is invalid
		system.assert( !IBANTool.checkDutchBankAccountNumber( bankAccountNr ) );
		
		bankAccountNr = '3130109';
		// numeric dutch bank account nr with less than 9 digits is valid
		system.assert( IBANTool.checkDutchBankAccountNumber( bankAccountNr ) );
		
		bankAccountNr = '313P0109';
		// non-numeric dutch bank account nr is invalid valid
		system.assert( !IBANTool.checkDutchBankAccountNumber( bankAccountNr ) );
	}

}
