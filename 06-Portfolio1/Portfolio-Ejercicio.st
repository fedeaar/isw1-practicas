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
