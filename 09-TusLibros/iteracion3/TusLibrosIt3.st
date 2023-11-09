!classDefinition: #CartTest category: 'TusLibros'!
TestCase subclass: #CartTest
	instanceVariableNames: 'testObjectsFactory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test01NewCartsAreCreatedEmpty

	self assert: testObjectsFactory createCart isEmpty! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test02CanNotAddItemsThatDoNotBelongToStore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [ cart add: testObjectsFactory itemNotSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test03AfterAddingAnItemTheCartIsNotEmptyAnymore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: testObjectsFactory itemSellByTheStore.
	self deny: cart isEmpty ! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test04CanNotAddNonPositiveNumberOfItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [cart add: 0 of: testObjectsFactory itemSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidQuantityErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test05CanNotAddMoreThanOneItemNotSellByTheStore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [cart add: 2 of: testObjectsFactory itemNotSellByTheStore  ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:11'!
test06CartRemembersAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: testObjectsFactory itemSellByTheStore.
	self assert: (cart includes: testObjectsFactory itemSellByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:11'!
test07CartDoesNotHoldNotAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self deny: (cart includes: testObjectsFactory itemSellByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:11'!
test08CartRemembersTheNumberOfAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: 2 of: testObjectsFactory itemSellByTheStore.
	self assert: (cart occurrencesOf: testObjectsFactory itemSellByTheStore) = 2! !


!CartTest methodsFor: 'setup' stamp: 'HernanWilkinson 6/17/2013 18:09'!
setUp 

	testObjectsFactory := StoreTestObjectsFactory new.! !


!classDefinition: #CashierTest category: 'TusLibros'!
TestCase subclass: #CashierTest
	instanceVariableNames: 'testObjectsFactory debitBehavior'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:50'!
test01CanNotCheckoutAnEmptyCart

	| salesBook |
	
	salesBook := OrderedCollection new.
	self 
		should: [ Cashier 
			toCheckout: testObjectsFactory createCart 
			charging: testObjectsFactory notExpiredCreditCard 
			throught: self
			on: testObjectsFactory today
			registeringOn:  salesBook ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier cartCanNotBeEmptyErrorMessage.
			self assert: salesBook isEmpty ]! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:51'!
test02CalculatedTotalIsCorrect

	| cart cashier |
	
	cart := testObjectsFactory createCart.
	cart add: 2 of: testObjectsFactory itemSellByTheStore.
	
	cashier :=  Cashier
		toCheckout: cart 
		charging: testObjectsFactory notExpiredCreditCard 
		throught: self
		on: testObjectsFactory today 
		registeringOn: OrderedCollection new.
		
	self assert: cashier checkOut = (testObjectsFactory itemSellByTheStorePrice * 2)! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:51'!
test03CanNotCheckoutWithAnExpiredCreditCart

	| cart salesBook |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	salesBook := OrderedCollection new.
	
	self
		should: [ Cashier 
				toCheckout: cart 
				charging: testObjectsFactory expiredCreditCard 
				throught: self
				on: testObjectsFactory today
				registeringOn: salesBook ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assert: anError messageText = Cashier canNotChargeAnExpiredCreditCardErrorMessage.
			self assert: salesBook isEmpty ]! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 19:04'!
test04CheckoutRegistersASale

	| cart cashier salesBook total |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	salesBook := OrderedCollection new.
 
	cashier:= Cashier 
		toCheckout: cart 
		charging: testObjectsFactory notExpiredCreditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	total := cashier checkOut.
					
	self assert: salesBook size = 1.
	self assert: salesBook first total = total.! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 19:00'!
test05CashierChargesCreditCardUsingMerchantProcessor

	| cart cashier salesBook total creditCard debitedAmout debitedCreditCard  |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	creditCard := testObjectsFactory notExpiredCreditCard.
	salesBook := OrderedCollection new.
 
	cashier:= Cashier 
		toCheckout: cart 
		charging: creditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	debitBehavior := [ :anAmount :aCreditCard | 
		debitedAmout := anAmount.
		debitedCreditCard := aCreditCard ].
	total := cashier checkOut.
					
	self assert: debitedCreditCard = creditCard.
	self assert: debitedAmout = total.! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:59'!
test06CashierDoesNotSaleWhenTheCreditCardHasNoCredit

	| cart cashier salesBook creditCard |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	creditCard := testObjectsFactory notExpiredCreditCard.
	salesBook := OrderedCollection new.
 	debitBehavior := [ :anAmount :aCreditCard | self error: Cashier creditCardHasNoCreditErrorMessage].
	
	cashier:= Cashier 
		toCheckout: cart 
		charging: creditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	self 
		should: [cashier checkOut ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier creditCardHasNoCreditErrorMessage.
			self assert: salesBook isEmpty ]! !


!CashierTest methodsFor: 'setup' stamp: 'HernanWilkinson 6/17/2013 19:03'!
setUp 

	testObjectsFactory := StoreTestObjectsFactory new.
	debitBehavior := [ :anAmount :aCreditCard | ]! !


!CashierTest methodsFor: 'merchant processor protocol' stamp: 'HernanWilkinson 6/17/2013 19:02'!
debit: anAmount from: aCreditCard 

	^debitBehavior value: anAmount value: aCreditCard ! !


!classDefinition: #InterfaceTest category: 'TusLibros'!
TestCase subclass: #InterfaceTest
	instanceVariableNames: 'testObjectsFactory authenticationValue debitBehavior authenticationBehavior'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!InterfaceTest methodsFor: 'tests' stamp: 'BK 11/8/2023 20:52:07'!
test01CannotAddCartWithInvalidCredentials

	| interface |
	
	interface := Interface with: self.
	
	authenticationValue := false.
	
	self 
		should: [interface createCartWithClientId: 'pepe' andPassword: 'pepito']
		raise: Error - MessageNotUnderstood
		withExceptionDo: [:anError |
			self assert: (anError messageText = Interface invalidCredentialsErrorDescription).
		]! !

!InterfaceTest methodsFor: 'tests' stamp: 'SC 11/6/2023 20:55:23'!
test02CanAddCartWithValidCredentials

	| interface cartId |
	
	interface := Interface with: self.
	
	authenticationValue := true.
	
	cartId := interface createCartWithClientId: 'pepeBueno' andPassword: 'pepito'.
	
	self assert: (interface listCartWithId: cartId) isEmpty.
! !

!InterfaceTest methodsFor: 'tests' stamp: 'SC 11/6/2023 21:30:10'!
test03InterfaceAddsValidItemToCart

	| interface cartId item expected |
	
	authenticationValue := true.
	
	interface := Interface 
		withCatalog: testObjectsFactory defaultCatalog
		andAuthenticator: self.
	
	item := testObjectsFactory itemSellByTheStore .
	
	expected := Dictionary new.
	expected add: (item->1).
	
	cartId := interface createCartWithClientId: 'pepeBueno' andPassword: 'pepito'.
	interface addToCartWithId: cartId withIsbn: item withOcurrances: 1.
	
	self assert: (interface listCartWithId: cartId) equals: expected.! !

!InterfaceTest methodsFor: 'tests' stamp: 'BK 11/8/2023 20:19:15'!
test04CanNotAddItemsThatDoNotBelongToStore

	| interface cartId item expected |
	
	authenticationValue := true.
	
	interface := Interface 
		withCatalog: testObjectsFactory defaultCatalog
		andAuthenticator: self.
	
	item := testObjectsFactory itemNotSellByTheStore .
	
	expected := Dictionary new.
	expected add: (item->1).
	
	cartId := interface createCartWithClientId: 'pepeBueno' andPassword: 'pepito'.
	
	self 
		should: [interface addToCartWithId: cartId withIsbn: item withOcurrances: 1.]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [:anError |
			self assert: (anError messageText = Interface invalidItemErrorMessage).
		]! !

!InterfaceTest methodsFor: 'tests' stamp: 'BK 11/8/2023 20:20:23'!
test05CanNotAddNonPositiveNumberOfItems

	| interface cartId item expected |
	
	authenticationValue := true.
	
	interface := Interface 
		withCatalog: testObjectsFactory defaultCatalog
		andAuthenticator: self.
	
	item := testObjectsFactory itemNotSellByTheStore .
	
	expected := Dictionary new.
	expected add: (item->1).
	
	cartId := interface createCartWithClientId: 'pepeBueno' andPassword: 'pepito'.
	
	self 
		should: [interface addToCartWithId: cartId withIsbn: item withOcurrances: 0.]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [:anError |
			self assert: (anError messageText = Interface invalidQuantityErrorMessage).
		]! !

!InterfaceTest methodsFor: 'tests' stamp: 'BK 11/8/2023 20:22:39'!
test06InterfaceAddsMultipleValidItemsToCart

	| interface cartId item expected |
	
	authenticationValue := true.
	
	interface := Interface 
		withCatalog: testObjectsFactory defaultCatalog
		andAuthenticator: self.
	
	item := testObjectsFactory itemSellByTheStore .
	
	expected := Dictionary new.
	expected
		add: (item->2).
	
	cartId := interface createCartWithClientId: 'pepeBueno' andPassword: 'pepito'.
	interface addToCartWithId: cartId withIsbn: item withOcurrances: 1.
	interface addToCartWithId: cartId withIsbn: item withOcurrances: 1.
	
	self assert: (interface listCartWithId: cartId) equals: expected.! !

!InterfaceTest methodsFor: 'tests' stamp: 'BK 11/8/2023 20:35:22'!
test07InterfaceFulfillsValidPurchase

	| interface cartId item card |
	
	authenticationValue := true.
	
	interface := Interface 
		withCatalog: testObjectsFactory defaultCatalog
		andAuthenticator: self
		andMerchant: self
		onDate: testObjectsFactory today.
	
	item := testObjectsFactory itemSellByTheStore .
	
	cartId := interface createCartWithClientId: 'pepeBueno' andPassword: 'pepito'.
	interface addToCartWithId: cartId withIsbn: item withOcurrances: 1.
	
	card := testObjectsFactory notExpiredCreditCard.
	
	interface checkoutCartWithID: cartId andCard: card.
	
	self assert: interface salesBook isEmpty not.
! !

!InterfaceTest methodsFor: 'tests' stamp: 'BK 11/8/2023 20:46:53'!
test08CanNotCheckoutAnEmptyCart

	| interface cartId card |
	
	authenticationValue := true.
	
	interface := Interface 
		withCatalog: testObjectsFactory defaultCatalog
		andAuthenticator: self
		andMerchant: self
		onDate: testObjectsFactory today.
	
	cartId := interface createCartWithClientId: 'pepeBueno' andPassword: 'pepito'.
	
	card := testObjectsFactory notExpiredCreditCard.
	
	self
		should: [ interface checkoutCartWithID: cartId andCard: card ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assert: anError messageText = Interface cartCanNotBeEmptyErrorMessage.
			self assert: interface salesBook isEmpty]
! !

!InterfaceTest methodsFor: 'tests' stamp: 'BK 11/8/2023 20:48:36'!
test09CanNotCheckoutWithAnExpiredCreditCart

	| interface cartId item card |
	
	authenticationValue := true.
	
	interface := Interface 
		withCatalog: testObjectsFactory defaultCatalog
		andAuthenticator: self
		andMerchant: self
		onDate: testObjectsFactory today.
	
	item := testObjectsFactory itemSellByTheStore .
	
	cartId := interface createCartWithClientId: 'pepeBueno' andPassword: 'pepito'.
	interface addToCartWithId: cartId withIsbn: item withOcurrances: 1.
	
	card := testObjectsFactory expiredCreditCard.
	
	self
		should: [ interface checkoutCartWithID: cartId andCard: card ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Interface canNotChargeAnExpiredCreditCardErrorMessage.
			self assert: interface salesBook isEmpty.]
! !

!InterfaceTest methodsFor: 'tests' stamp: 'BK 11/8/2023 20:49:42'!
test10CashierDoesNotSaleWhenTheCreditCardHasNoCredit

	| interface cartId item card |
	
	authenticationValue := true.
	
	debitBehavior := [ :anAmount :aCreditCard | self error: Cashier creditCardHasNoCreditErrorMessage].
	
	interface := Interface 
		withCatalog: testObjectsFactory defaultCatalog
		andAuthenticator: self
		andMerchant: self
		onDate: testObjectsFactory today.
	
	item := testObjectsFactory itemSellByTheStore .
	
	cartId := interface createCartWithClientId: 'pepeBueno' andPassword: 'pepito'.
	interface addToCartWithId: cartId withIsbn: item withOcurrances: 1.
	
	card := testObjectsFactory notExpiredCreditCard.
	
	self
		should: [ interface checkoutCartWithID: cartId andCard: card ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Interface creditCardHasNoCreditErrorMessage.
			self assert: interface salesBook isEmpty.]
! !


!InterfaceTest methodsFor: 'setup' stamp: 'BK 11/8/2023 20:42:45'!
setUp 

	testObjectsFactory := StoreTestObjectsFactory new.
	authenticationBehavior := [:aUsername :aPassword | ].
	debitBehavior := [ :anAmount :aCreditCard | ]! !


!InterfaceTest methodsFor: 'support' stamp: 'SC 11/6/2023 20:54:50'!
attemptLoginTo: aClientId with: aPassword 
	
	^authenticationValue! !

!InterfaceTest methodsFor: 'support' stamp: 'BK 11/8/2023 20:42:27'!
debit: anAmount from: aCreditCard 

	^debitBehavior value: anAmount value: aCreditCard ! !


!classDefinition: #Cart category: 'TusLibros'!
Object subclass: #Cart
	instanceVariableNames: 'catalog items'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:45'!
invalidItemErrorMessage
	
	^'Item is not in catalog'! !

!Cart methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:45'!
invalidQuantityErrorMessage
	
	^'Invalid number of items'! !


!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 18:06'!
assertIsValidItem: anItem

	(catalog includesKey: anItem) ifFalse: [ self error: self invalidItemErrorMessage ]! !

!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 17:51'!
assertIsValidQuantity: aQuantity

	aQuantity strictlyPositive ifFalse: [ self error: self invalidQuantityErrorMessage ]! !


!Cart methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 17:48'!
initializeAcceptingItemsOf: aCatalog

	catalog := aCatalog.
	items := OrderedCollection new.! !


!Cart methodsFor: 'queries' stamp: 'HernanWilkinson 6/17/2013 17:45'!
occurrencesOf: anItem

	^items occurrencesOf: anItem  ! !


!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
includes: anItem

	^items includes: anItem ! !

!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
isEmpty
	
	^items isEmpty ! !


!Cart methodsFor: 'total' stamp: 'SC 11/6/2023 21:07:40'!
items

	^items.! !

!Cart methodsFor: 'total' stamp: 'HernanWilkinson 6/17/2013 19:09'!
total

	^ items sum: [ :anItem | catalog at: anItem ]! !


!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/17/2013 17:44'!
add: anItem

	^ self add: 1 of: anItem ! !

!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/17/2013 17:51'!
add: aQuantity of: anItem

	self assertIsValidQuantity: aQuantity.
	self assertIsValidItem: anItem.

	1 to: aQuantity do: [ :aNumber | items add: anItem ]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'TusLibros'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 17:48'!
acceptingItemsOf: aCatalog

	^self new initializeAcceptingItemsOf: aCatalog ! !


!classDefinition: #Cashier category: 'TusLibros'!
Object subclass: #Cashier
	instanceVariableNames: 'cart salesBook merchantProcessor creditCard total'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:08'!
calculateTotal

	total := cart total.
	! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:07'!
createSale

	^ Sale of: total
! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:06'!
debitTotal

	merchantProcessor debit: total from: creditCard.
	! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:06'!
registerSale

	salesBook add: self createSale! !


!Cashier methodsFor: 'checkout' stamp: 'HernanWilkinson 6/17/2013 19:06'!
checkOut

	self calculateTotal.
	self debitTotal.
	self registerSale.

	^ total! !


!Cashier methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:53'!
initializeToCheckout: aCart charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook
	
	cart := aCart.
	creditCard := aCreditCard.
	merchantProcessor := aMerchantProcessor.
	salesBook := aSalesBook! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: 'TusLibros'!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 18:22'!
assertIsNotEmpty: aCart 
	
	aCart isEmpty ifTrue: [self error: self cartCanNotBeEmptyErrorMessage ]! !

!Cashier class methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 18:23'!
assertIsNotExpired: aCreditCard on: aDate
	
	(aCreditCard isExpiredOn: aDate) ifTrue: [ self error: self canNotChargeAnExpiredCreditCardErrorMessage ]! !


!Cashier class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 18:51'!
toCheckout: aCart charging: aCreditCard throught: aMerchantProcessor on: aDate registeringOn: aSalesBook
	
	self assertIsNotEmpty: aCart.
	self assertIsNotExpired: aCreditCard on: aDate.
	
	^self new initializeToCheckout: aCart charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook! !


!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 18:21'!
canNotChargeAnExpiredCreditCardErrorMessage
	
	^'Can not charge an expired credit card'! !

!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:56'!
cartCanNotBeEmptyErrorMessage
	
	^'Can not check out an empty cart'! !

!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 19:02'!
creditCardHasNoCreditErrorMessage
	
	^'Credit card has no credit'! !


!classDefinition: #CreditCard category: 'TusLibros'!
Object subclass: #CreditCard
	instanceVariableNames: 'expiration'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCard methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 18:39'!
isExpiredOn: aDate 
	
	^expiration start < (Month month: aDate monthIndex year: aDate yearNumber) start ! !


!CreditCard methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:38'!
initializeExpiringOn: aMonth 
	
	expiration := aMonth ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: 'TusLibros'!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 18:38'!
expiringOn: aMonth 
	
	^self new initializeExpiringOn: aMonth! !


!classDefinition: #Interface category: 'TusLibros'!
Object subclass: #Interface
	instanceVariableNames: 'credentialAuthenticator carts catalog merchantProcessor date salesBook'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Interface methodsFor: 'initialization' stamp: 'BK 11/8/2023 20:39:50'!
initializeWith: aCredentialAuthenticator 

	credentialAuthenticator := aCredentialAuthenticator.
	salesBook := OrderedCollection new.
	
	carts := Dictionary new.! !

!Interface methodsFor: 'initialization' stamp: 'SC 11/6/2023 21:05:04'!
initializeWithCatalog: anItemCatalog andAuthenticator: anAuthenticator 

	self initializeWith: anAuthenticator.
	catalog := anItemCatalog.
	! !

!Interface methodsFor: 'initialization' stamp: 'BK 11/8/2023 20:38:40'!
initializeWithCatalog: anItemCatalog andAuthenticator: anAuthenticator  andMerchant: aMerchantProcessor onDate: aDate

	self initializeWithCatalog: anItemCatalog andAuthenticator: anAuthenticator.
	merchantProcessor := aMerchantProcessor.
	date := aDate.
	! !


!Interface methodsFor: 'operators' stamp: 'SC 11/6/2023 21:03:04'!
addToCartWithId: cartId withIsbn: item withOcurrances: aQuantity

	(carts at: cartId) add: aQuantity of: item.

	 
	! !

!Interface methodsFor: 'operators' stamp: 'BK 11/8/2023 20:41:28'!
checkoutCartWithID: aCartID andCard: aCard

	| cart cashier |
	
	cart := (carts at: aCartID).
	
	cashier := Cashier
		toCheckout: cart
		charging: aCard
		throught: merchantProcessor
		on: date
		registeringOn: salesBook.
		
	^ cashier checkOut.

		! !

!Interface methodsFor: 'operators' stamp: 'BK 11/8/2023 20:53:26'!
createCartWithClientId: aClientId andPassword: aPassword

	(credentialAuthenticator attemptLoginTo: aClientId with: aPassword) ifFalse: [self error: self class invalidCredentialsErrorDescription].
	
	carts at: (carts size + 1) put: (Cart acceptingItemsOf: 	catalog).
	
	^ carts size.
	! !

!Interface methodsFor: 'operators' stamp: 'SC 11/6/2023 21:26:53'!
listCartWithId: cartId

	| cartItems cart |
	
	cart := (carts at: cartId) .
	cartItems := cart items asSet.
	
	^cartItems inject: Dictionary new into: [:occurrencesDictionary :anItem |
		occurrencesDictionary at: anItem put: (cart occurrencesOf: anItem); yourself
		]
	
! !


!Interface methodsFor: 'accessing' stamp: 'BK 11/8/2023 20:41:03'!
salesBook

	^ salesBook.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Interface class' category: 'TusLibros'!
Interface class
	instanceVariableNames: ''!

!Interface class methodsFor: 'error messages' stamp: 'BK 11/8/2023 20:50:30'!
canNotChargeAnExpiredCreditCardErrorMessage
	
	^ Cashier canNotChargeAnExpiredCreditCardErrorMessage.! !

!Interface class methodsFor: 'error messages' stamp: 'BK 11/8/2023 20:50:05'!
cartCanNotBeEmptyErrorMessage
	
	^ Cashier cartCanNotBeEmptyErrorMessage.! !

!Interface class methodsFor: 'error messages' stamp: 'BK 11/8/2023 20:51:26'!
creditCardHasNoCreditErrorMessage
	
	^ Cashier creditCardHasNoCreditErrorMessage.! !

!Interface class methodsFor: 'error messages' stamp: 'BK 11/8/2023 20:51:50'!
invalidCredentialsErrorDescription

	^ 'Invalid credentials'.! !

!Interface class methodsFor: 'error messages' stamp: 'BK 11/8/2023 20:17:44'!
invalidItemErrorMessage

	^ Cart new invalidItemErrorMessage.! !

!Interface class methodsFor: 'error messages' stamp: 'BK 11/8/2023 20:20:56'!
invalidQuantityErrorMessage

	^ Cart new invalidQuantityErrorMessage.! !


!Interface class methodsFor: 'instance creation' stamp: 'SC 11/6/2023 20:08:14'!
with: aCredentialAuthenticator 

	^self new initializeWith: aCredentialAuthenticator ! !

!Interface class methodsFor: 'instance creation' stamp: 'SC 11/6/2023 20:50:48'!
withCatalog: anItemCatalog andAuthenticator: anAuthenticator 

	^self new initializeWithCatalog: anItemCatalog andAuthenticator: anAuthenticator ! !

!Interface class methodsFor: 'instance creation' stamp: 'BK 11/8/2023 20:36:35'!
withCatalog: anItemCatalog andAuthenticator: anAuthenticator andMerchant: aMerchantProcessor onDate: aDate

	^self new initializeWithCatalog: anItemCatalog andAuthenticator: anAuthenticator andMerchant: aMerchantProcessor onDate: aDate! !


!classDefinition: #Sale category: 'TusLibros'!
Object subclass: #Sale
	instanceVariableNames: 'total'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Sale methodsFor: 'total' stamp: 'HernanWilkinson 6/17/2013 18:48'!
total
	
	^ total! !


!Sale methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:47'!
initializeTotal: aTotal

	total := aTotal ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Sale class' category: 'TusLibros'!
Sale class
	instanceVariableNames: ''!

!Sale class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 18:47'!
of: aTotal

	"should assert total is not negative or 0!!"
	^self new initializeTotal: aTotal ! !


!classDefinition: #StoreTestObjectsFactory category: 'TusLibros'!
Object subclass: #StoreTestObjectsFactory
	instanceVariableNames: 'today'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'HernanWilkinson 6/17/2013 18:08'!
itemNotSellByTheStore
	
	^'invalidBook'! !

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'HernanWilkinson 6/17/2013 18:08'!
itemSellByTheStore
	
	^ 'validBook'! !

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'HernanWilkinson 6/17/2013 18:08'!
itemSellByTheStorePrice
	
	^10! !


!StoreTestObjectsFactory methodsFor: 'cart' stamp: 'HernanWilkinson 6/17/2013 18:08'!
createCart
	
	^Cart acceptingItemsOf: self defaultCatalog! !

!StoreTestObjectsFactory methodsFor: 'cart' stamp: 'HernanWilkinson 6/17/2013 18:08'!
defaultCatalog
	
	^ Dictionary new
		at: self itemSellByTheStore put: self itemSellByTheStorePrice;
		yourself ! !


!StoreTestObjectsFactory methodsFor: 'credit card' stamp: 'HernanWilkinson 6/17/2013 18:37'!
expiredCreditCard
	
	^CreditCard expiringOn: (Month month: today monthIndex year: today yearNumber - 1)! !

!StoreTestObjectsFactory methodsFor: 'credit card' stamp: 'HernanWilkinson 6/17/2013 18:36'!
notExpiredCreditCard
	
	^CreditCard expiringOn: (Month month: today monthIndex year: today yearNumber + 1)! !


!StoreTestObjectsFactory methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:37'!
initialize

	today := DateAndTime now! !


!StoreTestObjectsFactory methodsFor: 'date' stamp: 'HernanWilkinson 6/17/2013 18:37'!
today
	
	^ today! !
