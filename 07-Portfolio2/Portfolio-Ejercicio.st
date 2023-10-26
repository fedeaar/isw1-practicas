!classDefinition: #AssetSummaryReportTest category: 'Portfolio-Ejercicio'!
TestCase subclass: #AssetSummaryReportTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!AssetSummaryReportTest methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:01:47'!
test01AccountSummaryShowsBalanceIfEmpty
	
	| account summary expected |
	
	account := ReceptiveAccount new.
	summary := AssetSummary generateReportFor: account.
	
	expected := OrderedCollection new.
	expected
		add: 'Balance = 0'.
	self assert: summary report = expected.! !

!AssetSummaryReportTest methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:01:49'!
test02AccountSummaryContainsDeposits
	
	| account summary expected |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	summary := AssetSummary generateReportFor: account.
	
	expected := OrderedCollection new.
	expected
		add: 'Depósito por 100.' ;
		add: 'Balance = 100'.
	self assert: summary report = expected.! !

!AssetSummaryReportTest methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:01:53'!
test03AccountSummaryContainsIncomingTransferences
	
	| account otherAccount summary expected |
	
	account := ReceptiveAccount new.
	otherAccount := ReceptiveAccount new.

	Transfer register: 30 from: otherAccount to: account. 
	
	summary := AssetSummary generateReportFor: account.
	expected := OrderedCollection new.
	expected
		add: 'Entrada por transferencia de 30.';
		add: 'Balance = 30'.
		
	self assert: summary report = expected.! !

!AssetSummaryReportTest methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:01:56'!
test03AccountSummaryContainsWithdrawals
	
	| account summary expected |
	
	account := ReceptiveAccount new.
	Deposit register: 50 on: account.
	Withdraw register: 25 on: account.
	summary := AssetSummary generateReportFor: account.
	
	expected := OrderedCollection new.
	expected
		add: 'Depósito por 50.' ;
		add: 'Extracción por 25.';
		add: 'Balance = 25'.
	self assert: summary report = expected.! !

!AssetSummaryReportTest methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:02:00'!
test04AccountSummaryContainsOutgoingTransferences
	
	| account otherAccount summary expected |
	
	account := ReceptiveAccount new.
	otherAccount := ReceptiveAccount new.

	Transfer register: 30 from: account to: otherAccount. 
	
	summary := AssetSummary generateReportFor: account.
	expected := OrderedCollection new.
	expected
		add: 'Salida por transferencia de 30.';
		add: 'Balance = -30'.
		
	self assert: summary report = expected.! !

!AssetSummaryReportTest methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:02:03'!
test05AccountSummaryReportIsGeneratedProperly
	
	| account otherAccount summary expected |
	
	account := ReceptiveAccount new.
	otherAccount := ReceptiveAccount new.
	
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
	Transfer register: 20 from: account to: otherAccount.
	Transfer register: 30 from: otherAccount to: account. 
	
	summary := AssetSummary generateReportFor: account.
	expected := OrderedCollection new.
	expected
		add: 'Depósito por 100.' ;
		add: 'Extracción por 50.';
		add: 'Salida por transferencia de 20.';
		add: 'Entrada por transferencia de 30.';
		add: 'Balance = 60'.
		
	self assert: summary report = expected.! !

!AssetSummaryReportTest methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:02:07'!
test06AccountSummaryRemainsStaticOnFurtherChanges
	
	| account otherAccount summary expected |
	
	account := ReceptiveAccount new.
	otherAccount := ReceptiveAccount new.
	
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
	Transfer register: 20 from: account to: otherAccount.
	Transfer register: 30 from: otherAccount to: account. 
	
	summary := AssetSummary generateReportFor: account.
	
	Deposit register: 20 on: account.
	Transfer register: 50 from: account to: otherAccount.
	
	expected := OrderedCollection new.
	expected
		add: 'Depósito por 100.' ;
		add: 'Extracción por 50.';
		add: 'Salida por transferencia de 20.';
		add: 'Entrada por transferencia de 30.';
		add: 'Balance = 60'.
		
	self assert: summary report = expected.! !

!AssetSummaryReportTest methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:02:10'!
test07PortfolioSummaryShowsBalanceIfEmpty
	
	| portfolio summary expected |
	
	portfolio := Portfolio new.
	summary := AssetSummary generateReportFor: portfolio.
	
	expected := OrderedCollection new.
	expected
		add: 'Balance = 0'.
	self assert: summary report = expected.! !

!AssetSummaryReportTest methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:02:14'!
test08PortfolioSummaryReportIsGeneratedProperlyForSingleChildStructure
	"
		A
	     /
	  a1 ... a2
	"
	| A a1 a2 summary expected |
	
	A := Portfolio new.
	a1 := ReceptiveAccount new.
	a2 := ReceptiveAccount new.
	
	A addAsset:  a1.
	
	Deposit register: 100 on: a1.
	Withdraw register: 50 on: a1.
	Transfer register: 20 from: a1 to: a2.
	Transfer register: 30 from: a2 to: a1. 
	
	summary := AssetSummary generateReportFor: a1.
	expected := OrderedCollection new.
	expected
		add: 'Depósito por 100.' ;
		add: 'Extracción por 50.';
		add: 'Salida por transferencia de 20.';
		add: 'Entrada por transferencia de 30.';
		add: 'Balance = 60'.
		
	self assert: summary report = expected.! !

!AssetSummaryReportTest methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:02:18'!
test09PortfolioSummaryReportIsGeneratedLeftToRightForMultipleChildStructure
	"
		A
	     /    |
	  a1 ... a2
	"
	| A a1 a2 summary expected |
	
	A := Portfolio new.
	a1 := ReceptiveAccount new.
	a2 := ReceptiveAccount new.
	
	A addAsset:  a1.
	A addAsset: a2.
	
	Deposit register: 100 on: a1.
	Withdraw register: 50 on: a1.
	Transfer register: 20 from: a1 to: a2.
	Deposit register: 60 on: a2.
	Withdraw register: 30 on: a2.
	Transfer register: 30 from: a2 to: a1. 
	
	summary := AssetSummary generateReportFor: A.
	expected := OrderedCollection new.
	expected
		"reporte a1"
		add: 'Depósito por 100.' ;
		add: 'Extracción por 50.';
		add: 'Salida por transferencia de 20.';
		add: 'Entrada por transferencia de 30.';
		"reporte a2"
		add: 'Entrada por transferencia de 20.';
		add: 'Depósito por 60.' ;
		add: 'Extracción por 30.';
		add: 'Salida por transferencia de 30.';
		add: 'Balance = 80'.
		
	self assert: summary report = expected.! !

!AssetSummaryReportTest methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:02:23'!
test10PortfolioSummaryReportIsGeneratedLeftToRightForMultiLevelChildStructure
	"
		A
	     /    \			
	  a1     B
		    \
	            a2
	"
	| A B a1 a2 summary expected |
	
	A := Portfolio new.
	B := Portfolio new.
	a1 := ReceptiveAccount new.
	a2 := ReceptiveAccount new.
	
	A addAsset:  a1.
	A addAsset: B.
	B addAsset: a2.
	
	Deposit register: 100 on: a1.
	Withdraw register: 50 on: a1.
	Transfer register: 20 from: a1 to: a2.
	Deposit register: 60 on: a2.
	Withdraw register: 30 on: a2.
	Transfer register: 30 from: a2 to: a1. 
	
	summary := AssetSummary generateReportFor: A.
	expected := OrderedCollection new.
	expected
		"reporte a1"
		add: 'Depósito por 100.' ;
		add: 'Extracción por 50.';
		add: 'Salida por transferencia de 20.';
		add: 'Entrada por transferencia de 30.';
		"reporte a2"
		add: 'Entrada por transferencia de 20.';
		add: 'Depósito por 60.' ;
		add: 'Extracción por 30.';
		add: 'Salida por transferencia de 30.';
		add: 'Balance = 80'.
		
	self assert: summary report = expected.! !


!classDefinition: #NetTransferReportTest category: 'Portfolio-Ejercicio'!
TestCase subclass: #NetTransferReportTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!NetTransferReportTest methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:18:34'!
test01AccountNetTransferIsCero
	
	| account summary |
	
	account := ReceptiveAccount new.
	summary := NetTransfer generateReportFor: account.
	
	self assert: summary report = 0.! !

!NetTransferReportTest methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:18:50'!
test02AccountNetTransferDoesNotIncludeDepositsOrWithdrawals
	
	| account summary |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	summary := NetTransfer generateReportFor: account.
	
	self assert: summary report = 0.! !

!NetTransferReportTest methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:19:11'!
test03AccountNetTransferSumsIncomingTransferences
	
	| account otherAccount summary |
	
	account := ReceptiveAccount new.
	otherAccount := ReceptiveAccount new.

	Transfer register: 30 from: otherAccount to: account. 
	
	summary := NetTransfer generateReportFor: account.
		
	self assert: summary report = 30.! !

!NetTransferReportTest methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:19:30'!
test04AccountNetTransferSubstractsOutgoingTransferences
	
	| account otherAccount summary |
	
	account := ReceptiveAccount new.
	otherAccount := ReceptiveAccount new.

	Transfer register: 30 from: account to: otherAccount. 
	
	summary := NetTransfer generateReportFor: account.
		
	self assert: summary report = -30.! !

!NetTransferReportTest methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:19:55'!
test05AccountNetTransferIsCalculatedProperly
	
	| account otherAccount summary |
	
	account := ReceptiveAccount new.
	otherAccount := ReceptiveAccount new.
	
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
	Transfer register: 20 from: account to: otherAccount.
	Transfer register: 30 from: otherAccount to: account. 
	
	summary := NetTransfer generateReportFor: account.
		
	self assert: summary report = 10.! !

!NetTransferReportTest methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:20:08'!
test06PortfolioNetTransferIsCero
	
	| portfolio summary |
	
	portfolio := Portfolio new.
	summary := NetTransfer generateReportFor: portfolio.
	
	self assert: summary report = 0.! !

!NetTransferReportTest methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:20:41'!
test07PortfolioNetTransferIsCalculatedProperlyForSingleChildStructure
	"
		A
	     /
	  a1 ... a2
	"
	| A a1 a2 summary |
	
	A := Portfolio new.
	a1 := ReceptiveAccount new.
	a2 := ReceptiveAccount new.
	
	A addAsset:  a1.
	
	Deposit register: 100 on: a1.
	Withdraw register: 50 on: a1.
	Transfer register: 20 from: a1 to: a2.
	Transfer register: 30 from: a2 to: a1. 
	
	summary := NetTransfer generateReportFor: a1.
		
	self assert: summary report = 10.
	! !

!NetTransferReportTest methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:21:48'!
test08PortfolioNetTransferIsCalculatedProperlyForMultipleChildStructure
	"
		A
	     /    |
	  a1 ... a2
	"
	| A a1 a2 summary |
	
	A := Portfolio new.
	a1 := ReceptiveAccount new.
	a2 := ReceptiveAccount new.
	
	A addAsset:  a1.
	A addAsset: a2.
	
	Deposit register: 100 on: a1.
	Withdraw register: 50 on: a1.
	Transfer register: 20 from: a1 to: a2.
	Deposit register: 60 on: a2.
	Withdraw register: 30 on: a2.
	Transfer register: 30 from: a2 to: a1. 
	
	summary := NetTransfer generateReportFor: A.
		
	self assert: summary report = 0.
	! !

!NetTransferReportTest methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:23:25'!
test09PortfolioNetTransferIsCalculatedProperlyForMultiLevelChildStructure
	"
		A
	     /    \			
	  a1     B
		    \
	            a2 ... a3
	"
	| A B a1 a2 a3 summary |
	
	A := Portfolio new.
	B := Portfolio new.
	a1 := ReceptiveAccount new.
	a2 := ReceptiveAccount new.
	a3 := ReceptiveAccount new.
	
	A addAsset:  a1.
	A addAsset: B.
	B addAsset: a2.
	
	Deposit register: 100 on: a1.
	Withdraw register: 50 on: a1.
	Transfer register: 20 from: a1 to: a2.
	Deposit register: 60 on: a2.
	Withdraw register: 30 on: a2.
	Transfer register: 30 from: a2 to: a1. 
	Transfer register: 30 from: a2 to: a3.
	
	summary := NetTransfer generateReportFor: A.
		
	self assert: summary report = -30.
	! !


!classDefinition: #PortfolioTest category: 'Portfolio-Ejercicio'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!PortfolioTest methodsFor: 'docs' stamp: 'fa 10/18/2023 22:55:12'!
conceptualReference 
	"
	formada a medida que se desarrolló el ejercicio.
	
	ejemplo (mayus. portfolio, minus. cuenta):
	
		A   B
	      /	  \/  \
	    C   D   e
	   /	/ \ 	
	 e   F  G   H
		/  \  /  \
	       i	    j     i
		
	conceptualmente:
		- un asset puede pertenecer a varios portfolios
		- un asset no puede estar repetido en un portfolio
	esto genera las siguientes observaciones:

		- el asset no puede estar en un subportfolio propio (ya está en el portfolio)
		- el asset no puede estar en un superportfolio  (agregarlo rompe el contrato 
		de este otro)
		- el asset puede estar en otro portfolio que también contenga a alguno de 
		mis subportfolios (son independientes)
	"! !


!PortfolioTest methodsFor: 'tests' stamp: 'fa 10/18/2023 22:36:48'!
test01PortfolioHasZeroAsBalanceWhenCreated
	"
	estructura:
		P1
	"
	| P1 |
	
	P1 := Portfolio new.
	
	self assert: P1 balance = 0.! !

!PortfolioTest methodsFor: 'tests' stamp: 'fa 10/18/2023 20:53:04'!
test02D́epositIncreasesAndWithdrawDecreasesBalanceOnTransactionValue 
	"
	estructura:
		P1
	       /
	 a1:100
	"
	| A1 P1 |
	
	P1 := Portfolio new.
	A1 := ReceptiveAccount new.
	
	P1 addAsset: A1.
	Deposit register: 100 on: A1.
	self assert: P1 balance = 100.
	Withdraw register: 50 on: A1.
	self assert: P1 balance = 50.
! !

!PortfolioTest methodsFor: 'tests' stamp: 'fa 10/18/2023 22:37:10'!
test03BalanceChangesOnAddingAccount
	"
	estructura:
		P1
	       /
	 a1:100
	"
	| A1 P1 |
	
	P1 := Portfolio new.
	A1 := ReceptiveAccount  new.		
	
	P1 addAsset: A1.
	Deposit register: 100 on: A1.
	self assert: P1 balance = 100.
! !

!PortfolioTest methodsFor: 'tests' stamp: 'fa 10/18/2023 22:37:41'!
test04BalanceChangesOnAddingPortfolio
	"
	estructura:
		P1
	       /
	    P2
	    /
	a1:100
	"
	| A1 P1 P2 |
	
	P1 := Portfolio new.
	P2 := Portfolio new.
	A1 := ReceptiveAccount  new.
	
	Deposit register: 100 on: A1.
	P2 addAsset: A1.
	self assert: P1 balance = 0.
	P1 addAsset: P2.
	self assert: P1 balance = 100.
! !

!PortfolioTest methodsFor: 'tests' stamp: 'fa 10/18/2023 22:41:08'!
test05PortfolioKnowsRegisteredTransactions
	"
	estructura:
		P1
	       /
	 a1:50
	"
	| P1 a1 deposit withdraw |
	
	P1 := Portfolio new.
	a1 := ReceptiveAccount new.
	
	deposit := Deposit register: 100 on: a1.
	withdraw := Withdraw register: 50 on: a1.
	P1 addAsset: a1.
	self assert: (P1 hasRegistered: deposit).
	self assert: (P1 hasRegistered: withdraw).! !

!PortfolioTest methodsFor: 'tests' stamp: 'fa 10/18/2023 22:41:42'!
test06PortfolioKnowsRegisteredTransactionsOverGenerations
	"
	estructura:
		P1
	       /
	    P2
	    /
	a1:50
	"
	| P1 P2 a1 deposit withdraw |
	
	P1 := Portfolio new.
	P2 := Portfolio new.
	a1 := ReceptiveAccount new.
	
	deposit := Deposit register: 100 on: a1.
	withdraw := Withdraw register: 50 on: a1.
	P2 addAsset: a1.
	P1 addAsset: P2.
	self assert: (P1 hasRegistered: deposit).
	self assert: (P1 hasRegistered: withdraw).! !

!PortfolioTest methodsFor: 'tests' stamp: 'fa 10/18/2023 22:42:41'!
test07PortfolioKnowsItsTransactions 
	"
	estructura:
		P1
	       /
	 a1:50
	"
	| P1 a1 deposit |
	
	P1 := Portfolio new.
	a1 := ReceptiveAccount new.
	
	deposit := Deposit register: 50 on: a1.
	P1 addAsset: a1.
	self assert: 1 equals: P1 transactions size.
	self assert: (P1 transactions includes: deposit).
! !

!PortfolioTest methodsFor: 'tests' stamp: 'fa 10/18/2023 22:43:42'!
test08PortfolioDoesNotKnowNotRegisteredTransactions
	"
	estructura:
		P1
	       /
	 a1:150
	"
	| P1 a1 deposit withdraw |
	
	P1 := Portfolio new.
	a1 := ReceptiveAccount new.
	
	deposit :=  Deposit for: 200.
	withdraw := Withdraw for: 50.
	P1 addAsset: a1.
	self deny: (P1 hasRegistered: deposit).
	self deny: (P1 hasRegistered:withdraw).
! !

!PortfolioTest methodsFor: 'tests' stamp: 'fa 10/18/2023 22:45:02'!
test09PortfolioKnowsItsTransactionsOverGenerations
	"
	estructura:
		P1
	       /
	    P2
	    /
	a1:50
	"
	| P1 P2 a1 deposit |
	
	P1 := Portfolio new.
	P2 := Portfolio new.
	a1 := ReceptiveAccount new.
	
	deposit := Deposit register: 50 on: a1.
	P2 addAsset: a1.
	P1 addAsset: P2.
	self assert: 1 equals: P1 transactions size.
	self assert: (P1 transactions includes: deposit).
! !

!PortfolioTest methodsFor: 'tests' stamp: 'fa 10/18/2023 22:45:56'!
test10AssetCannotBeAddedTwiceToTheSamePortfolio
	"
	estructura:
		P1
	       //
	    P2
	"
	| P1 P2 |
	
	P2 := Portfolio new.
	P1 := Portfolio new.
	
	P1 addAsset: P2.
	self 
		should: [P1 addAsset: P2.]
		raise: Error
		withExceptionDo: [ :anException | 
			self assert: anException messageText equals: AssetState attemptedToAddDuplicateAssetErrorDescription.
		].
! !

!PortfolioTest methodsFor: 'tests' stamp: 'fa 10/18/2023 22:47:41'!
test11PortfolioCanBeShared
	"
	estructura:
		P1  P2
	       	 \   /
	    	 P3
	"
	| P1 P2 P3 |
	
	P1 := Portfolio new.
	P2 := Portfolio new.
	P3 := Portfolio new.
	
	P1 addAsset: P3.
	P2 addAsset: P3.
	self assert: (
		(P1 holds: P3) and: 
		(P2 holds: P3)
	). 
! !

!PortfolioTest methodsFor: 'tests' stamp: 'fa 10/18/2023 22:54:28'!
test12AssetCannotBeAddedIfItBelongsToTheCurrentPortfolio
	"
	estructura:
		P1
	       /  \\
	    P2  ||
	      \	 //
	      a1      
	"
	| P1 P2 a1 |
	
	P1 := Portfolio new.
	P2 := Portfolio new.
	a1 := ReceptiveAccount new.
	
	P1 addAsset: P2.
	P2 addAsset: a1.
	self 
		should: [P1 addAsset: a1.]
		raise: Error
		withExceptionDo: [ :anException | 
			self assert: anException messageText equals: AssetState attemptedToAddDuplicateAssetErrorDescription.
		].
! !

!PortfolioTest methodsFor: 'tests' stamp: 'fa 10/18/2023 22:54:32'!
test13AssetCannotBeAddedIfItBelongsToThePortfolioCurrentPortfolioBelongsTo
	"
	estructura:
		P1
	       /  \
	    P2  P3
	      \	 //
	      a1      
	"
	| P1 P2 P3 a1 |
	
	P1 := Portfolio new.
	P2 := Portfolio new.
	P3 := Portfolio new.
	a1 := ReceptiveAccount new.
	
	P1 addAsset: P2.
	P1 addAsset: P3.
	P2 addAsset: a1.
	self 
		should: [P3 addAsset: a1.]
		raise: Error
		withExceptionDo: [ :anException | 
			self assert: anException messageText equals: AssetState attemptedToAddDuplicateAssetErrorDescription.
		].! !

!PortfolioTest methodsFor: 'tests' stamp: 'fa 10/18/2023 22:54:43'!
test14AssetCanBeAddedIfItBelongsToAnotherParentPortfolioOfSomeSharedChildPortfolio 
	"
	estructura:
	       P1  P2
	      /	  \/   \
	   a1	 P3  a1
	"
	| P1 P2 P3 a1 |
	
	P1 := Portfolio new.
	P2 := Portfolio new.
	P3 := Portfolio new.
	a1 := ReceptiveAccount new.
	
	P1 addAsset: P3.
	P1 addAsset: a1.
	P2 addAsset: P3.
	P2 addAsset: a1.
	
	self assert: (
		(P1 holds: a1) and: 
		(P2 holds: a1) and: 
		(P3 holds: a1) not
	)
	
	
! !


!classDefinition: #ReceptiveAccountTest category: 'Portfolio-Ejercicio'!
TestCase subclass: #ReceptiveAccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:44'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	| account |
	
	account := ReceptiveAccount new.

	self assert: 0 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:48'!
test02DepositIncreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount  new.
	Deposit register: 100 on: account.
		
	self assert: 100 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:52'!
test03WithdrawDecreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
		
	self assert: 50 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:32'!
test04WithdrawValueMustBePositive 

	| account withdrawValue |
	
	account := ReceptiveAccount new.
	withdrawValue := 50.
	
	self assert: withdrawValue equals: (Withdraw register: withdrawValue on: account) value
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:46'!
test05ReceptiveAccountKnowsRegisteredTransactions 

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	withdraw := Withdraw register: 50 on: account.
		
	self assert: (account hasRegistered: deposit).
	self assert: (account hasRegistered: withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 5/17/2021 17:29:53'!
test06ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| deposit withdraw account |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 200.
	withdraw := Withdraw for: 50.
		
	self deny: (account hasRegistered: deposit).
	self deny: (account hasRegistered:withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:14:01'!
test07AccountKnowsItsTransactions 

	| account1 deposit1 |
	
	account1 := ReceptiveAccount new.
	
	deposit1 := Deposit register: 50 on: account1.
		
	self assert: 1 equals: account1 transactions size.
	self assert: (account1 transactions includes: deposit1).
! !


!classDefinition: #TransferTest category: 'Portfolio-Ejercicio'!
TestCase subclass: #TransferTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!TransferTest methodsFor: 'as yet unclassified' stamp: 'fa 10/25/2023 20:50:48'!
test01aCoveredTransferIncrementsTheIncomingAccountBalance

	| incomingAccount outgoingAccount |
	
	incomingAccount := ReceptiveAccount new.
	outgoingAccount := ReceptiveAccount new.
	
	Deposit register: 100 on: outgoingAccount.
	Transfer register: 100 from: outgoingAccount to: incomingAccount. 
	
	self assert: incomingAccount balance = 100.! !

!TransferTest methodsFor: 'as yet unclassified' stamp: 'fa 10/25/2023 20:51:20'!
test02aCoveredTransferDecrementsTheOutgoingAccountBalance

	| incomingAccount outgoingAccount |
	
	incomingAccount := ReceptiveAccount new.
	outgoingAccount := ReceptiveAccount new.
	
	Deposit register: 100 on: outgoingAccount.
	Transfer register: 100 from: outgoingAccount to: incomingAccount. 
	
	self assert: outgoingAccount balance = 0.! !

!TransferTest methodsFor: 'as yet unclassified' stamp: 'fa 10/25/2023 20:52:12'!
test03aCoveredTransferIncrementsAndDecrementsTheRespectiveAccounts

	| incomingAccount outgoingAccount |
	
	incomingAccount := ReceptiveAccount new.
	outgoingAccount := ReceptiveAccount new.
	
	Deposit register: 100 on: outgoingAccount.
	Transfer register: 100 from: outgoingAccount to: incomingAccount. 
	
	self assert: outgoingAccount balance = 0.
	self assert: incomingAccount balance = 100.! !

!TransferTest methodsFor: 'as yet unclassified' stamp: 'fa 10/25/2023 20:53:13'!
test04anAccountCanMakeAnUncoveredTransfer

	| incomingAccount outgoingAccount |
	
	incomingAccount := ReceptiveAccount new.
	outgoingAccount := ReceptiveAccount new.
	
	Transfer register: 100 from: outgoingAccount to: incomingAccount. 
	
	self assert: outgoingAccount balance = -100.
	self assert: incomingAccount balance = 100.
	! !

!TransferTest methodsFor: 'as yet unclassified' stamp: 'fa 10/25/2023 21:08:08'!
test05transfersAreRegisteredInBothEndsOfTransaction

	| incomingAccount outgoingAccount |
	
	incomingAccount := ReceptiveAccount new.
	outgoingAccount := ReceptiveAccount new.
	
	Deposit register: 100 on: outgoingAccount.
	Transfer register: 100 from: outgoingAccount to: incomingAccount. 
	
	self assert: incomingAccount transactions size = 1.
	self assert: outgoingAccount transactions size = 2.
	! !

!TransferTest methodsFor: 'as yet unclassified' stamp: 'fa 10/25/2023 21:16:09'!
test06transferAllowsToReachOtherEndOfTransaction

	| incomingAccount outgoingAccount |
	
	incomingAccount := ReceptiveAccount new.
	outgoingAccount := ReceptiveAccount new.
	
	Deposit register: 100 on: outgoingAccount.
	Transfer register: 100 from: outgoingAccount to: incomingAccount. 
	
	self assert: (incomingAccount transactions last counterparty) = outgoingAccount.
	self assert: (outgoingAccount transactions last counterparty) = incomingAccount.
	! !


!classDefinition: #AccountTransaction category: 'Portfolio-Ejercicio'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!AccountTransaction methodsFor: 'value' stamp: 'fa 10/25/2023 23:01:43'!
addToReport: aReport 

	self subclassResponsibility.! !

!AccountTransaction methodsFor: 'value' stamp: 'fa 10/25/2023 20:41:36'!
fulfilmentValue 

	self subclassResponsibility.! !

!AccountTransaction methodsFor: 'value' stamp: 'fa 10/25/2023 20:41:33'!
value 

	self subclassResponsibility.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransaction class' category: 'Portfolio-Ejercicio'!
AccountTransaction class
	instanceVariableNames: ''!

!AccountTransaction class methodsFor: 'instance creation' stamp: 'NR 10/17/2019 03:22:00'!
register: aValue on: account

	| transaction |
	
	transaction := self for: aValue.
	account register: transaction.
		
	^ transaction! !


!classDefinition: #Deposit category: 'Portfolio-Ejercicio'!
AccountTransaction subclass: #Deposit
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Deposit methodsFor: 'initialization' stamp: 'BK 10/16/2023 18:49:18'!
initializeFor: aValue

	value := aValue ! !


!Deposit methodsFor: 'value' stamp: 'fa 10/25/2023 23:44:48'!
addToReport: aReport
	
	^aReport addDepositTransactionToReportWithValue: value.! !

!Deposit methodsFor: 'value' stamp: 'BK 10/16/2023 18:55:43'!
fulfilmentValue

	^ value! !

!Deposit methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:38'!
value

	^ value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Deposit class' category: 'Portfolio-Ejercicio'!
Deposit class
	instanceVariableNames: ''!

!Deposit class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:38'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Transfer category: 'Portfolio-Ejercicio'!
AccountTransaction subclass: #Transfer
	instanceVariableNames: 'transfer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Transfer methodsFor: 'as yet unclassified' stamp: 'fa 10/25/2023 21:14:51'!
counterparty

	self subclassResponsibility.! !

!Transfer methodsFor: 'as yet unclassified' stamp: 'fa 10/25/2023 20:41:42'!
fulfilmentValue 

	self subclassResponsibility.! !

!Transfer methodsFor: 'as yet unclassified' stamp: 'fa 10/25/2023 20:42:37'!
initializeFor: aTransferData

	transfer := aTransferData.! !

!Transfer methodsFor: 'as yet unclassified' stamp: 'fa 10/25/2023 20:42:11'!
value

	^ transfer value.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Transfer class' category: 'Portfolio-Ejercicio'!
Transfer class
	instanceVariableNames: ''!

!Transfer class methodsFor: 'as yet unclassified' stamp: 'fa 10/25/2023 20:44:34'!
register: aValue from: anOutgoingAccount to: anIncomingAccount

	| transfer outgoingTransfer incomingTransfer |
	
	transfer := TransferData new initializeFor: aValue from: anOutgoingAccount to: anIncomingAccount.
	
	outgoingTransfer := OutgoingTransfer for: transfer.
	incomingTransfer := IncomingTransfer for: transfer.
	
	anOutgoingAccount register: outgoingTransfer.
	anIncomingAccount register: incomingTransfer.
		
	^ transfer. 
! !


!classDefinition: #IncomingTransfer category: 'Portfolio-Ejercicio'!
Transfer subclass: #IncomingTransfer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!IncomingTransfer methodsFor: 'as yet unclassified' stamp: 'fa 10/25/2023 23:44:42'!
addToReport: aReport
	
	^aReport addIncomingTransferTransactionToReportWithValue: self value.! !

!IncomingTransfer methodsFor: 'as yet unclassified' stamp: 'fa 10/25/2023 21:14:51'!
counterparty

	^ transfer outgoingAccount.! !

!IncomingTransfer methodsFor: 'as yet unclassified' stamp: 'fa 10/25/2023 20:44:54'!
fulfilmentValue

	^ self value.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IncomingTransfer class' category: 'Portfolio-Ejercicio'!
IncomingTransfer class
	instanceVariableNames: ''!

!IncomingTransfer class methodsFor: 'as yet unclassified' stamp: 'fa 10/25/2023 20:44:16'!
for: aTransfer

	^ self new initializeFor: aTransfer. ! !


!classDefinition: #OutgoingTransfer category: 'Portfolio-Ejercicio'!
Transfer subclass: #OutgoingTransfer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!OutgoingTransfer methodsFor: 'as yet unclassified' stamp: 'fa 10/25/2023 23:44:38'!
addToReport: aReport
	
	^aReport addOutgoingTransferTransactionToReportWithValue: self value.! !

!OutgoingTransfer methodsFor: 'as yet unclassified' stamp: 'fa 10/25/2023 21:14:51'!
counterparty

	^ transfer incomingAccount.! !

!OutgoingTransfer methodsFor: 'as yet unclassified' stamp: 'fa 10/25/2023 20:45:05'!
fulfilmentValue

	^ 0 - self value.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OutgoingTransfer class' category: 'Portfolio-Ejercicio'!
OutgoingTransfer class
	instanceVariableNames: ''!

!OutgoingTransfer class methodsFor: 'as yet unclassified' stamp: 'fa 10/25/2023 20:44:22'!
for: aTransfer

	^ self new initializeFor: aTransfer. ! !


!classDefinition: #Withdraw category: 'Portfolio-Ejercicio'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Withdraw methodsFor: 'initialization' stamp: 'BK 10/16/2023 18:50:45'!
initializeFor: aValue

	value := aValue ! !


!Withdraw methodsFor: 'value' stamp: 'fa 10/25/2023 23:44:35'!
addToReport: aReport
	
	^aReport addWithdrawTransactionToReportWithValue: value.! !

!Withdraw methodsFor: 'value' stamp: 'BK 10/16/2023 18:55:20'!
fulfilmentValue

	^ 0-value! !

!Withdraw methodsFor: 'value' stamp: 'BK 10/16/2023 18:50:41'!
value

	^ value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: 'Portfolio-Ejercicio'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:33'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Asset category: 'Portfolio-Ejercicio'!
Object subclass: #Asset
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Asset methodsFor: 'state' stamp: 'fa 10/18/2023 21:04:46'!
addParentAsset: anAsset 

	^ self subclassResponsibility.! !

!Asset methodsFor: 'state' stamp: 'fa 10/18/2023 20:59:53'!
changeStateTo: state 

	^ self subclassResponsibility.! !

!Asset methodsFor: 'state' stamp: 'fa 10/18/2023 20:59:21'!
holds: anAsset 

	^ self subclassResponsibility.! !

!Asset methodsFor: 'state' stamp: 'fa 10/18/2023 20:59:34'!
someParentAssetHolds: anAsset 

	^ self subclassResponsibility.! !


!Asset methodsFor: 'transactions' stamp: 'fa 10/18/2023 20:40:05'!
addTransactionsTo: anOrderedCollection 

	^ self subclassResponsibility.! !

!Asset methodsFor: 'transactions' stamp: 'BK 10/16/2023 19:16:49'!
transactions 

	^ self subclassResponsibility.! !


!Asset methodsFor: 'balance' stamp: 'BK 10/16/2023 19:16:33'!
balance 

	^ self subclassResponsibility.! !


!Asset methodsFor: 'testing' stamp: 'BK 10/16/2023 19:17:47'!
hasRegistered: aTransaction

	^ self subclassResponsibility.! !


!classDefinition: #Portfolio category: 'Portfolio-Ejercicio'!
Asset subclass: #Portfolio
	instanceVariableNames: 'state'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Portfolio methodsFor: 'transactions' stamp: 'fa 10/18/2023 20:34:11'!
addTransactionsTo: anOrderedCollection 

	self assets do: [ :anAsset | anAsset addTransactionsTo: anOrderedCollection ].! !

!Portfolio methodsFor: 'transactions' stamp: 'fa 10/18/2023 20:38:37'!
transactions 

	| acc |
	
	acc := OrderedCollection new.
	self assets do: [ :anAsset | anAsset addTransactionsTo: acc ].
	
	^ acc.! !


!Portfolio methodsFor: 'state' stamp: 'fa 10/18/2023 20:37:18'!
addAsset: anAsset

	state addChildAsset: anAsset.! !

!Portfolio methodsFor: 'state' stamp: 'fa 10/18/2023 20:36:59'!
addParentAsset: anAsset

	state addParentAsset: anAsset.! !

!Portfolio methodsFor: 'state' stamp: 'fa 10/25/2023 23:44:23'!
addToReport: aReport

	state childAssets do: [ :asset | aReport addAssetToReport: asset].! !

!Portfolio methodsFor: 'state' stamp: 'fa 10/18/2023 20:33:56'!
assets

	^ state childAssets.! !

!Portfolio methodsFor: 'state' stamp: 'fa 10/18/2023 19:16:23'!
changeStateTo: newState
	
	state := newState.! !

!Portfolio methodsFor: 'state' stamp: 'fa 10/18/2023 20:58:52'!
holds: anAsset

	^state holds: anAsset.! !

!Portfolio methodsFor: 'state' stamp: 'fa 10/18/2023 20:49:57'!
someParentAssetHolds: anAsset

	^state someParentAssetHolds: anAsset.! !


!Portfolio methodsFor: 'initialization' stamp: 'fa 10/18/2023 20:53:52'!
initialize
	
	state := RootState for: self.! !


!Portfolio methodsFor: 'testing' stamp: 'fa 10/18/2023 20:34:45'!
hasRegistered: aTransaction

	^self assets anySatisfy: [ :anAsset | anAsset hasRegistered: aTransaction ].! !


!Portfolio methodsFor: 'balance' stamp: 'fa 10/18/2023 21:13:14'!
balance

	^self assets sum: [ :anAsset | anAsset balance ] ifEmpty: [0].! !


!classDefinition: #ReceptiveAccount category: 'Portfolio-Ejercicio'!
Asset subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions state'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'fa 10/18/2023 21:07:06'!
initialize

	state := LeafState for: self.
	transactions := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'transactions' stamp: 'fa 10/25/2023 23:44:08'!
addToReport: aReport

	transactions do: [ :transaction | aReport addTransactionToReport: transaction ].! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'fa 10/18/2023 20:39:52'!
addTransactionsTo: anOrderedCollection 

	anOrderedCollection addAll: transactions.! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
register: aTransaction

	transactions add: aTransaction 
! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
transactions 

	^ transactions copy! !


!ReceptiveAccount methodsFor: 'balance' stamp: 'fa 10/18/2023 21:13:31'!
balance

	^transactions sum: [ :aTransaction | aTransaction fulfilmentValue ] ifEmpty: [ 0 ].! !


!ReceptiveAccount methodsFor: 'testing' stamp: 'NR 10/17/2019 03:28:43'!
hasRegistered: aTransaction

	^ transactions includes: aTransaction 
! !


!ReceptiveAccount methodsFor: 'state' stamp: 'fa 10/18/2023 21:09:20'!
addParentAsset: anAsset

	state addParentAsset: anAsset.! !

!ReceptiveAccount methodsFor: 'state' stamp: 'fa 10/18/2023 21:10:05'!
changeStateTo: newState
	
	state := newState.! !

!ReceptiveAccount methodsFor: 'state' stamp: 'fa 10/18/2023 21:08:07'!
holds: anAsset 

	^state holds: anAsset.! !


!classDefinition: #AssetReport category: 'Portfolio-Ejercicio'!
Object subclass: #AssetReport
	instanceVariableNames: 'assetReference generatedReport'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!AssetReport methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:05:10'!
addAssetToReport: anAsset

	self subclassResponsibility.
! !

!AssetReport methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:04:54'!
addDepositTransactionToReportWithValue: aValue

	self subclassResponsibility.! !

!AssetReport methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:04:48'!
addIncomingTransferTransactionToReportWithValue: aValue

	self subclassResponsibility.! !

!AssetReport methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:05:23'!
addOutgoingTransferTransactionToReportWithValue: aValue

	self subclassResponsibility.! !

!AssetReport methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:05:32'!
addTransactionToReport: aTransaction

	self subclassResponsibility.! !

!AssetReport methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:05:41'!
addWithdrawTransactionToReportWithValue: aValue

	self subclassResponsibility.! !

!AssetReport methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:05:50'!
display

	self subclassResponsibility.! !

!AssetReport methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:06:00'!
generateReportFor: anAsset

	self subclassResponsibility.! !

!AssetReport methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:06:07'!
report

	self subclassResponsibility.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AssetReport class' category: 'Portfolio-Ejercicio'!
AssetReport class
	instanceVariableNames: ''!

!AssetReport class methodsFor: 'as yet unclassified' stamp: 'fa 10/25/2023 23:16:09'!
generateReportFor: anAsset

	^ self new generateReportFor: anAsset.! !


!classDefinition: #AssetSummary category: 'Portfolio-Ejercicio'!
AssetReport subclass: #AssetSummary
	instanceVariableNames: 'report'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!AssetSummary methodsFor: 'as yet unclassified' stamp: 'fa 10/25/2023 23:59:38'!
addAssetToReport: anAsset

	anAsset addToReport: self.
! !

!AssetSummary methodsFor: 'as yet unclassified' stamp: 'fa 10/25/2023 23:59:34'!
addBalanceToReportFrom: anAsset
	
	report add: 'Balance = ', (anAsset balance asString).! !

!AssetSummary methodsFor: 'as yet unclassified' stamp: 'fa 10/25/2023 23:43:20'!
addDepositTransactionToReportWithValue: aValue

	report add: ('Depósito por ', (aValue asString), '.'). 
! !

!AssetSummary methodsFor: 'as yet unclassified' stamp: 'fa 10/25/2023 23:43:28'!
addIncomingTransferTransactionToReportWithValue: aValue

	^ report add: ('Entrada por transferencia de ', (aValue asString), '.'). 
! !

!AssetSummary methodsFor: 'as yet unclassified' stamp: 'fa 10/25/2023 23:43:36'!
addOutgoingTransferTransactionToReportWithValue: aValue

	^ report add: ('Salida por transferencia de ', (aValue asString), '.'). 
! !

!AssetSummary methodsFor: 'as yet unclassified' stamp: 'fa 10/25/2023 23:42:29'!
addTransactionToReport: aTransaction

	aTransaction addToReport: self.
! !

!AssetSummary methodsFor: 'as yet unclassified' stamp: 'fa 10/25/2023 23:43:45'!
addWithdrawTransactionToReportWithValue: aValue

	report add: ('Extracción por ', (aValue asString), '.'). 
! !

!AssetSummary methodsFor: 'as yet unclassified' stamp: 'fa 10/25/2023 23:55:00'!
display
	
	report do: [ :line | Transcript show: line ; newLine ].
! !

!AssetSummary methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:01:02'!
generateReportFor: anAsset
	
	report := OrderedCollection new.
	anAsset addToReport: self.
	self addBalanceToReportFrom: anAsset.
	
	^self.
! !

!AssetSummary methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:01:15'!
report
	
	^report.
! !


!classDefinition: #NetTransfer category: 'Portfolio-Ejercicio'!
AssetReport subclass: #NetTransfer
	instanceVariableNames: 'report netTransfer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!NetTransfer methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:08:38'!
addAssetToReport: anAsset

	anAsset addToReport: self.
! !

!NetTransfer methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:11:38'!
addDepositTransactionToReportWithValue: aValue

	"do nothing." 
! !

!NetTransfer methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:12:46'!
addIncomingTransferTransactionToReportWithValue: aValue

	netTransfer := netTransfer + aValue.
! !

!NetTransfer methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:12:55'!
addOutgoingTransferTransactionToReportWithValue: aValue

	netTransfer := netTransfer - aValue.
! !

!NetTransfer methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:09:25'!
addTransactionToReport: aTransaction

	aTransaction addToReport: self.

! !

!NetTransfer methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:13:10'!
addWithdrawTransactionToReportWithValue: aValue

	"do nothing."
! !

!NetTransfer methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:11:02'!
display
	
	Transcript show:  netTransfer asString.
! !

!NetTransfer methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:10:37'!
generateReportFor: anAsset
	
	netTransfer := 0.
	anAsset addToReport: self.
	
	^self.
! !

!NetTransfer methodsFor: 'as yet unclassified' stamp: 'fa 10/26/2023 00:10:45'!
report
	
	^netTransfer .

! !


!classDefinition: #AssetState category: 'Portfolio-Ejercicio'!
Object subclass: #AssetState
	instanceVariableNames: 'assetReference'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!AssetState methodsFor: 'initialization' stamp: 'fa 10/18/2023 20:15:34'!
initialize

	^self subclassResponsibility.! !


!AssetState methodsFor: 'getters' stamp: 'fa 10/18/2023 20:08:05'!
childAssets

	^self subclassResponsibility.! !

!AssetState methodsFor: 'getters' stamp: 'fa 10/18/2023 20:08:10'!
parentAssets

	^self subclassResponsibility.! !


!AssetState methodsFor: 'testing' stamp: 'fa 10/18/2023 20:30:37'!
referencesOrHolds: anAsset

	^self subclassResponsibility.! !

!AssetState methodsFor: 'testing' stamp: 'fa 10/18/2023 20:09:13'!
someChildAssetHolds: anAsset

	^self subclassResponsibility.! !

!AssetState methodsFor: 'testing' stamp: 'fa 10/18/2023 20:09:18'!
someParentAssetHolds: anAsset

	^self subclassResponsibility.! !


!AssetState methodsFor: 'setters' stamp: 'fa 10/18/2023 20:08:56'!
addChildAsset: anAsset

	^self subclassResponsibility.! !

!AssetState methodsFor: 'setters' stamp: 'fa 10/18/2023 20:09:02'!
addParentAsset: anAsset

	^self subclassResponsibility.! !

!AssetState methodsFor: 'setters' stamp: 'fa 10/18/2023 19:53:38'!
setAssetReference: anAsset

	assetReference := anAsset.! !

!AssetState methodsFor: 'setters' stamp: 'fa 10/18/2023 22:21:13'!
setChildAssets: anAsset

	^self subclassResponsibility.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AssetState class' category: 'Portfolio-Ejercicio'!
AssetState class
	instanceVariableNames: ''!

!AssetState class methodsFor: 'instance creation' stamp: 'fa 10/18/2023 20:20:05'!
for: anAsset

	^ self subclassResponsibility.! !


!AssetState class methodsFor: 'error descriptions' stamp: 'fa 10/18/2023 22:17:47'!
attemptedToAddDuplicateAssetErrorDescription

	^ 'Attempted to add a duplicate to the same tree.'! !


!classDefinition: #LeafState category: 'Portfolio-Ejercicio'!
AssetState subclass: #LeafState
	instanceVariableNames: 'ParentAssets parentAssets'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!LeafState methodsFor: 'initialization' stamp: 'fa 10/18/2023 21:05:41'!
initialize

	parentAssets := OrderedCollection new.! !


!LeafState methodsFor: 'testing' stamp: 'fa 10/18/2023 22:36:26'!
holds: anAsset

	^assetReference == anAsset.
	! !


!LeafState methodsFor: 'setters' stamp: 'fa 10/18/2023 21:05:56'!
addParentAsset: anAsset

	parentAssets add: anAsset.! !


!LeafState methodsFor: 'getters' stamp: 'fa 10/18/2023 21:06:12'!
parentAssets

	^parentAssets.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LeafState class' category: 'Portfolio-Ejercicio'!
LeafState class
	instanceVariableNames: ''!

!LeafState class methodsFor: 'instance creation' stamp: 'fa 10/18/2023 21:07:33'!
for: anAsset

	|state|
	
	state := LeafState new.
	state setAssetReference: anAsset.
	
	^state.! !


!classDefinition: #RootState category: 'Portfolio-Ejercicio'!
AssetState subclass: #RootState
	instanceVariableNames: 'childAssets'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!RootState methodsFor: 'getters' stamp: 'fa 10/18/2023 20:19:06'!
childAssets

	^childAssets.! !

!RootState methodsFor: 'getters' stamp: 'fa 10/18/2023 20:18:52'!
parentAssets

	^self error: 'RootState has no parents'.! !


!RootState methodsFor: 'initialization' stamp: 'fa 10/18/2023 20:16:49'!
initialize

	childAssets := OrderedCollection new.! !


!RootState methodsFor: 'testing' stamp: 'fa 10/18/2023 20:57:51'!
holds: anAsset

	^(assetReference  == anAsset) or: (self someChildAssetHolds: anAsset).! !

!RootState methodsFor: 'testing' stamp: 'fa 10/18/2023 21:03:22'!
someChildAssetHolds: anAsset

	^childAssets anySatisfy: [ :childAsset |  childAsset holds: anAsset ].! !

!RootState methodsFor: 'testing' stamp: 'fa 10/18/2023 20:58:08'!
someParentAssetHolds: anAsset

	^self holds: anAsset.! !


!RootState methodsFor: 'setters' stamp: 'fa 10/18/2023 22:32:06'!
addChildAsset: anAsset
	
	(self someParentAssetHolds: anAsset) ifTrue: [
		^self error: self class attemptedToAddDuplicateAssetErrorDescription.
	].
	childAssets add: anAsset.
	anAsset addParentAsset: assetReference.! !

!RootState methodsFor: 'setters' stamp: 'fa 10/18/2023 21:19:11'!
addParentAsset: anAsset

	assetReference changeStateTo: (InnerState for: assetReference withParent: anAsset andChildren: childAssets).! !

!RootState methodsFor: 'setters' stamp: 'fa 10/18/2023 22:19:44'!
setChildAssets: children
	"
	metodo privado.
	"
	childAssets := children.
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'RootState class' category: 'Portfolio-Ejercicio'!
RootState class
	instanceVariableNames: ''!

!RootState class methodsFor: 'instance creation' stamp: 'fa 10/18/2023 20:20:51'!
for: anAsset

	|state|
	
	state := RootState new.
	state setAssetReference: anAsset.
	
	^state.! !


!classDefinition: #InnerState category: 'Portfolio-Ejercicio'!
RootState subclass: #InnerState
	instanceVariableNames: 'parentAssets'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!InnerState methodsFor: 'initialization' stamp: 'fa 10/18/2023 21:15:19'!
initialize

	childAssets := OrderedCollection new.
	parentAssets := OrderedCollection new.! !


!InnerState methodsFor: 'setters' stamp: 'fa 10/18/2023 20:10:02'!
addParentAsset: anAsset

	parentAssets add: anAsset.! !


!InnerState methodsFor: 'getters' stamp: 'fa 10/18/2023 20:14:59'!
parentAssets

	^parentAssets.! !


!InnerState methodsFor: 'testing' stamp: 'fa 10/18/2023 20:11:43'!
someParentAssetHolds: anAsset

	^parentAssets anySatisfy: [ :parentAsset |  parentAsset someParentAssetHolds: anAsset ].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'InnerState class' category: 'Portfolio-Ejercicio'!
InnerState class
	instanceVariableNames: ''!

!InnerState class methodsFor: 'instance creation' stamp: 'fa 10/18/2023 20:21:24'!
for: anAsset 

	|state|
	
	state := InnerState new.
	state setAssetReference:  anAsset.
	
	^state. 
! !

!InnerState class methodsFor: 'instance creation' stamp: 'fa 10/18/2023 20:21:14'!
for: anAsset withParent: aParentAsset
	
	|state|
	
	state := InnerState new.
	state setAssetReference:  anAsset.
	state addParentAsset: aParentAsset.
	
	^state. ! !

!InnerState class methodsFor: 'instance creation' stamp: 'fa 10/18/2023 22:19:27'!
for: anAsset withParent: aParentAsset andChildren: childrenAssets
	
	|state|
	
	state := InnerState new.
	state setAssetReference:  anAsset.
	state addParentAsset: aParentAsset.
	state setChildAssets: childrenAssets.
	
	^state. ! !


!classDefinition: #TransferData category: 'Portfolio-Ejercicio'!
Object subclass: #TransferData
	instanceVariableNames: 'value outgoingAccount incomingAccount'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!TransferData methodsFor: 'as yet unclassified' stamp: 'fa 10/25/2023 20:45:36'!
incomingAccount 

	^ incomingAccount.
	! !

!TransferData methodsFor: 'as yet unclassified' stamp: 'fa 10/25/2023 20:38:00'!
initializeFor: aValue from: anOutgoingAccount to: anIncomingAccount.

	value := aValue.
	outgoingAccount := anOutgoingAccount.
	incomingAccount := anIncomingAccount.! !

!TransferData methodsFor: 'as yet unclassified' stamp: 'fa 10/25/2023 20:45:44'!
outgoingAccount 

	^ outgoingAccount.
	! !

!TransferData methodsFor: 'as yet unclassified' stamp: 'fa 10/25/2023 20:45:26'!
value

	^ value.
	! !
