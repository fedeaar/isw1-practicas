!classDefinition: #PortfolioTest category: 'Portfolio-Ejercicio'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'BK 10/16/2023 19:27:33'!
test01PortfolioHasZeroAsBalanceWhenCreated

	| portfolio |

	portfolio := Portfolio new.
	
	self assert: portfolio balance = 0.! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'BK 10/16/2023 19:21:03'!
test02DepositIncreasesBalanceOnAddingAccount

	| account portfolio |
	
	account := ReceptiveAccount  new.
	Deposit register: 100 on: account.
		
	portfolio := Portfolio new.
	portfolio add: account.
	
	self assert: portfolio balance = 100.! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'BK 10/16/2023 19:33:09'!
test03DepositIncreasesBalanceOnAddingPortfolio

	| account parentPortfolio childPortfolio |
	
	parentPortfolio := Portfolio new.
	
	childPortfolio := Portfolio new.
	parentPortfolio add: childPortfolio.
	
	account := ReceptiveAccount  new.
	Deposit register: 100 on: account.
	childPortfolio add: account.
	
	self assert: parentPortfolio balance = 100.! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'BK 10/16/2023 19:31:15'!
test04WithdrawDecreasesBalanceOnTransactionValue 

	| account portfolio |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	
	portfolio := Portfolio new.
	portfolio add: account.
	
	Withdraw register: 50 on: account.
	
	self assert: portfolio balance = 50.! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'BK 10/16/2023 19:52:40'!
test05PortfolioKnowsRegisteredTransactions

	| account deposit withdraw portfolio |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	withdraw := Withdraw register: 50 on: account.
	
	portfolio := Portfolio new.
	portfolio add: account.
	
	self assert: (portfolio hasRegistered: deposit).
	self assert: (portfolio hasRegistered: withdraw).! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'BK 10/16/2023 20:29:56'!
test06PortfolioKnowsRegisteredTransactionsOverGenerations

	| account deposit withdraw childPortfolio parentPortfolio |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	withdraw := Withdraw register: 50 on: account.
	
	childPortfolio := Portfolio new.
	childPortfolio add: account.
	
	parentPortfolio := Portfolio new.
	parentPortfolio add: childPortfolio.
	
	self assert: (parentPortfolio hasRegistered: deposit).
	self assert: (parentPortfolio hasRegistered: withdraw).! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'BK 10/16/2023 19:59:10'!
test07PortfolioKnowsItsTransactions 

	| account deposit portfolio |
	
	account := ReceptiveAccount new.
	
	deposit := Deposit register: 50 on: account.
	
	portfolio := Portfolio new.
	portfolio add: account.
		
	self assert: 1 equals: portfolio transactions size.
	self assert: (portfolio transactions includes: deposit).
! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'BK 10/16/2023 20:30:30'!
test08PortfolioDoesNotKnowNotRegisteredTransactions

	| deposit withdraw account portfolio |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 200.
	withdraw := Withdraw for: 50.
	
	portfolio := Portfolio new.
	portfolio add: account.
		
	self deny: (portfolio hasRegistered: deposit).
	self deny: (portfolio hasRegistered:withdraw).
! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'BK 10/16/2023 20:30:25'!
test09PortfolioKnowsItsTransactionsOverGenerations

	| account deposit parentPortfolio childPortfolio |
	
	account := ReceptiveAccount new.
	
	deposit := Deposit register: 50 on: account.
	
	childPortfolio := Portfolio new.
	childPortfolio add: account.
	
	parentPortfolio := Portfolio new.
	parentPortfolio add: childPortfolio.
		
	self assert: 1 equals: parentPortfolio transactions size.
	self assert: (parentPortfolio transactions includes: deposit).
! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'BK 10/16/2023 20:37:01'!
test10PortfolioCannotBeAddedTwiceToTheSameTree

	| parentPortfolio childPortfolio |
	
	childPortfolio := Portfolio new.
	
	parentPortfolio := Portfolio new.
	parentPortfolio add: childPortfolio.
	
	self 
		should: [parentPortfolio add: childPortfolio.]
		raise: Error
		withExceptionDo: [ :anException | 
			self assert: anException equals: Portfolio attemptedToAddDuplicateErrorDescription.
		].
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


!classDefinition: #AbstractAsset category: 'Portfolio-Ejercicio'!
Object subclass: #AbstractAsset
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!AbstractAsset methodsFor: 'as yet unclassified' stamp: 'BK 10/16/2023 19:16:33'!
balance 

	^ self subclassResponsibility.! !

!AbstractAsset methodsFor: 'as yet unclassified' stamp: 'BK 10/16/2023 19:17:47'!
hasRegistered: aTransaction

	^ self subclassResponsibility.! !

!AbstractAsset methodsFor: 'as yet unclassified' stamp: 'BK 10/16/2023 19:16:49'!
transactions 

	^ self subclassResponsibility.! !


!classDefinition: #Portfolio category: 'Portfolio-Ejercicio'!
AbstractAsset subclass: #Portfolio
	instanceVariableNames: 'contents'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Portfolio methodsFor: 'as yet unclassified' stamp: 'BK 10/16/2023 20:52:11'!
add: anAsset

	contents add: anAsset.! !

!Portfolio methodsFor: 'as yet unclassified' stamp: 'BK 10/16/2023 20:50:25'!
balance

	^ contents sum: [ :anAsset | anAsset balance ] ifEmpty: [0].! !

!Portfolio methodsFor: 'as yet unclassified' stamp: 'BK 10/16/2023 20:50:30'!
hasRegistered: aTransaction

	^ contents anySatisfy: [ :anAsset | anAsset hasRegistered: aTransaction ].! !

!Portfolio methodsFor: 'as yet unclassified' stamp: 'BK 10/16/2023 20:44:14'!
initialize
	
	contents := OrderedCollection new.! !

!Portfolio methodsFor: 'as yet unclassified' stamp: 'BK 10/16/2023 20:50:37'!
transactions 

	| acc |
	
	acc := OrderedCollection new.
	
	contents do: [ :anAsset | 
		acc addAll: ( anAsset transactions )
	].

	^ acc.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Portfolio class' category: 'Portfolio-Ejercicio'!
Portfolio class
	instanceVariableNames: ''!

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'BK 10/16/2023 20:37:27'!
attemptedToAddDuplicateErrorDescription

	^ self error: 'Attempted to add a duplicate to the same tree.'! !


!classDefinition: #ReceptiveAccount category: 'Portfolio-Ejercicio'!
AbstractAsset subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'NR 10/17/2019 15:06:56'!
initialize

	transactions := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
register: aTransaction

	transactions add: aTransaction 
! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
transactions 

	^ transactions copy! !


!ReceptiveAccount methodsFor: 'balance' stamp: 'BK 10/16/2023 18:56:05'!
balance

	^transactions sum: [ :aTransaction | aTransaction fulfilmentValue ] ifEmpty: [ 0 ]! !


!ReceptiveAccount methodsFor: 'testing' stamp: 'NR 10/17/2019 03:28:43'!
hasRegistered: aTransaction

	^ transactions includes: aTransaction 
! !


!classDefinition: #AccountTransaction category: 'Portfolio-Ejercicio'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!AccountTransaction methodsFor: 'value' stamp: 'BK 10/16/2023 18:55:58'!
fulfilmentValue 

	self subclassResponsibility ! !

!AccountTransaction methodsFor: 'value' stamp: 'HernanWilkinson 9/12/2011 12:25'!
value 

	self subclassResponsibility ! !

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


!classDefinition: #Withdraw category: 'Portfolio-Ejercicio'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Withdraw methodsFor: 'initialization' stamp: 'BK 10/16/2023 18:50:45'!
initializeFor: aValue

	value := aValue ! !


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
