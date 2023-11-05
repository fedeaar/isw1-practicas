!classDefinition: #CashierTest category: 'TusLibros'!
TestCase subclass: #CashierTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CashierTest methodsFor: 'tests' stamp: 'BK 11/5/2023 12:20:02'!
test01cannotProcessEmptyCart

	| cart cashier |

	cart := PurchaseCart forStore: self defaultCatalog.
	cashier := self createCashier.
	
	self 
		should: [ cashier process: cart ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText = cashier cannotProcessEmptyCartError.
		].
	
	! !

!CashierTest methodsFor: 'tests' stamp: 'BK 11/5/2023 12:43:58'!
test02canProcessOneValidItem

	| cart cashier amount expectedAmount |

	cart := self createCart.
	cart add: self itemInCatalog copies: 1.
	
	cashier := self createCashier.
	
	amount := cashier process: cart.
	expectedAmount := (self defaultCatalog at: self itemInCatalog).
	
	self assert: amount = expectedAmount.
	
	! !

!CashierTest methodsFor: 'tests' stamp: 'BK 11/5/2023 12:44:16'!
test03canProcessMultipleValidItems

	| cart cashier amount expectedAmount |

	cart := self createCart.
	cart
		add: self itemInCatalog copies: 1;
		add: self item2inCatalog copies: 2.
	
	cashier := self createCashier.
	
	amount := cashier process: cart.
	expectedAmount :=
		(self defaultCatalog at: self itemInCatalog) +
		((self defaultCatalog at: self item2inCatalog) * 2).
	
	self assert: amount = expectedAmount.
	
	! !

!CashierTest methodsFor: 'tests' stamp: 'BK 11/5/2023 12:43:50'!
test04cannotProcessItemsNotInCatalog

	| cart cashier |

	cart := self createCart.
	cart
		add: self itemNotInCatalog copies: 1.
	
	cashier := self createCashier.
	
	self 
		should: [ cashier process: cart ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText = cashier itemNotInCatalogError.
		].
	
	! !


!CashierTest methodsFor: 'support' stamp: 'BK 11/5/2023 12:30:36'!
createCart

	| cart |
	
	cart := PurchaseCart forStore: self defaultStore.
	
	^ cart
	! !

!CashierTest methodsFor: 'support' stamp: 'BK 11/5/2023 12:19:40'!
createCashier

	| cashier |
	
	cashier := Cashier withCatalog: self defaultCatalog.
	
	^ cashier
	! !

!CashierTest methodsFor: 'support' stamp: 'BK 11/5/2023 12:44:16'!
defaultCatalog

	| catalog |
	
	catalog := Dictionary new.
	catalog
		add: (self itemInCatalog -> 1);
		add: (self item2inCatalog -> 2).

	^ catalog.! !

!CashierTest methodsFor: 'support' stamp: 'BK 11/5/2023 12:44:40'!
defaultStore

	| catalog |
	
	catalog := Dictionary new.
	catalog
		add: (self itemInCatalog -> 100);
		add: (self item2inCatalog  -> 100);
		add: (self itemNotInCatalog -> 100).

	^ catalog.! !

!CashierTest methodsFor: 'support' stamp: 'BK 11/5/2023 12:44:16'!
item2inCatalog

	^ 'validItem2'! !

!CashierTest methodsFor: 'support' stamp: 'BK 11/5/2023 12:43:58'!
itemInCatalog

	^ 'validItem'! !

!CashierTest methodsFor: 'support' stamp: 'BK 11/5/2023 12:43:50'!
itemNotInCatalog

	^ 'invalidItem'! !


!classDefinition: #MerchantProcessorBridgeTest category: 'TusLibros'!
TestCase subclass: #MerchantProcessorBridgeTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!MerchantProcessorBridgeTest methodsFor: 'utils' stamp: 'fa 11/2/2023 23:51:25'!
defaultBridge

	^MerchantProcessorBridge with: (NullHTTPRequester new) forMerchantHost: 'dummy-host'.! !

!MerchantProcessorBridgeTest methodsFor: 'utils' stamp: 'fa 11/2/2023 23:51:40'!
paymentOf: aTotalAmount forCardWithCCN: aCreditCardString expirationDate: anExpirationDateString andOwner: aCardOwnerString  shouldRaise: anErrorMessage

	self should: [ 
		self defaultBridge 
			processPaymentOf: aTotalAmount 
			forCardWithCCN:  aCreditCardString 
			expirationDate: anExpirationDateString 
			andOwner: aCardOwnerString.
		]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: anErrorMessage.
		].
! !


!MerchantProcessorBridgeTest methodsFor: 'tests' stamp: 'fa 11/2/2023 21:20:09'!
test01noAceptaNumerosDeTarjetaConCaracteresNoNuméricos

	self 
		paymentOf: 123.22 
		forCardWithCCN:  'unaTarjetaDeCredito' 
		expirationDate:  '012024'
		andOwner:  'Pablo Lescano'
		shouldRaise: MerchantProcessorBridge invalidCreditCardNumberError.
! !

!MerchantProcessorBridgeTest methodsFor: 'tests' stamp: 'fa 11/2/2023 21:20:39'!
test02noAceptaFechasDeExpiracionQueNoSeanSeisDigitos

	self 
		paymentOf: 123.22 
		forCardWithCCN:  '420000000001' 
		expirationDate:  '12024'
		andOwner:  'Pablo Lescano'
		shouldRaise: MerchantProcessorBridge invalidExpirationDateError .
! !

!MerchantProcessorBridgeTest methodsFor: 'tests' stamp: 'fa 11/2/2023 21:20:53'!
test03noAceptaFechasDeExpiracionQueNoTenganUnMesValido

	self 
		paymentOf: 123.22 
		forCardWithCCN:  '420000000001' 
		expirationDate:  '132024'
		andOwner:  'Pablo Lescano'
		shouldRaise: MerchantProcessorBridge invalidExpirationDateError .
! !

!MerchantProcessorBridgeTest methodsFor: 'tests' stamp: 'fa 11/2/2023 21:21:09'!
test04noAceptaFechasDeExpiracionQueYaHayanExpirado

	self 
		paymentOf: 123.22 
		forCardWithCCN:  '420000000001' 
		expirationDate:  '122020'
		andOwner:  'Pablo Lescano'
		shouldRaise: MerchantProcessorBridge invalidExpirationDateError .
! !

!MerchantProcessorBridgeTest methodsFor: 'tests' stamp: 'fa 11/2/2023 21:24:01'!
test05noAceptaNombresDeTarjetaDeMasDeTreintaCaracteres

	self 
		paymentOf: 123.22 
		forCardWithCCN:  '420000000001' 
		expirationDate:  '122024'
		andOwner:  'Pablo Lescano Mariano de los Santo Dominguez Labrador Inminente'
		shouldRaise: MerchantProcessorBridge invalidCreditCardOwnerError.! !

!MerchantProcessorBridgeTest methodsFor: 'tests' stamp: 'fa 11/2/2023 21:26:54'!
test06noAceptaNombresDeTarjetaNoAlfabeticos

	self 
		paymentOf: 123.22 
		forCardWithCCN:  '420000000001' 
		expirationDate:  '122024'
		andOwner:  'El Demoledor 777'
		shouldRaise: MerchantProcessorBridge invalidCreditCardOwnerError.! !

!MerchantProcessorBridgeTest methodsFor: 'tests' stamp: 'fa 11/2/2023 22:53:49'!
test07noAceptaTransaccionesConMasDeDosDigitosDespuesDeLaComa

	self 
		paymentOf: 123.222 
		forCardWithCCN:  '420000000001' 
		expirationDate:  '122024'
		andOwner:  'El Demoledor Maveric'
		shouldRaise: MerchantProcessorBridge invalidTransactionAmountError.! !

!MerchantProcessorBridgeTest methodsFor: 'tests' stamp: 'fa 11/2/2023 22:53:41'!
test08noAceptaTransaccionesConMasDeQuinceDigitosAntesDeLaComa

	self 
		paymentOf: 123123123123123.22 
		forCardWithCCN:  '420000000001' 
		expirationDate:  '122024'
		andOwner:  'El Demoledor Maveric'
		shouldRaise: MerchantProcessorBridge invalidTransactionAmountError.! !

!MerchantProcessorBridgeTest methodsFor: 'tests' stamp: 'fa 11/2/2023 23:52:19'!
test09formateaCorrectamenteLaCantidadADebitar
	
	| bridge |
	
	bridge := self defaultBridge.
	
	self assert: (bridge formatOrRejectTransactionAmount: 123.2) equals: '123.20'.
	self assert: (bridge formatOrRejectTransactionAmount: 123) equals: '123.00'.
	self assert: (bridge formatOrRejectTransactionAmount: 123.23) equals: '123.23'.! !

!MerchantProcessorBridgeTest methodsFor: 'tests' stamp: 'fa 11/2/2023 23:52:34'!
test10formateaCorrectamenteElNombreDeLaTarjeta

	self assert: (self defaultBridge formatOrRejectCreditCardOwner: 'Pablo Lescano') equals: 'PABLO%20LESCANO'.! !

!MerchantProcessorBridgeTest methodsFor: 'tests' stamp: 'fa 11/2/2023 23:54:16'!
test11generaCorrectamenteElURLparaRealizarElPost

	self assert: (
		self defaultBridge 
			createQueryStringWithCCN: '420000000001' 
			expirationDate:  '022027'
			cardOwner:  'Pablo Lescano'
			andTransactionAmount: 127)
		equals: 'dummy-host?creditCardNumber=420000000001&creditCardExpiration=022027&creditCardOwner=PABLO%20LESCANO&transactionAmount=127.00'.
! !

!MerchantProcessorBridgeTest methodsFor: 'tests' stamp: 'fa 11/2/2023 23:54:06'!
test12retornaCorrectamenteLaDescripcionDeErrorGeneradaPorElMerchantProcessor

	| bridge httpRequester |

	httpRequester := MockHTTPRequester new.	
	httpRequester 
		shouldResolveWithCode: 200 
		andMessage: '1|El pago fue rechazado por fondos insuficientes'. 
		
	bridge := MerchantProcessorBridge with: httpRequester forMerchantHost: 'dummy-host'.
	
	self assert: (
		bridge
			processPaymentOf: 127 
			forCardWithCCN:  '420000000001' 
			expirationDate: '022034' 
			andOwner: 'Hernan Espineta')
		equals:
			(OrderedCollection with: 200 with: '1|El pago fue rechazado por fondos insuficientes').
! !


!classDefinition: #PurchaseCartTest category: 'TusLibros'!
TestCase subclass: #PurchaseCartTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!PurchaseCartTest methodsFor: 'tests' stamp: 'fa 11/2/2023 19:33:59'!
test01elCarritoComienzaVacio

	| cart store |
	
	store := Dictionary new.
	cart := PurchaseCart forStore: store.
	
	store
		add: '1234'->3 ;
		add: '2345'->2 . 	
		
	self assert: cart isEmpty.
! !

!PurchaseCartTest methodsFor: 'tests' stamp: 'fa 11/2/2023 19:33:39'!
test02sePuedeAgregarUnLibroAlCarrito

	| cart store |
	
	store := Dictionary new.
	cart := PurchaseCart forStore: store.
	
	store
		add: '1234'->3 ;
		add: '2345'->2 .
		 	
	cart add: '1234' copies: 1.

	self assert: (cart isEmpty not).
! !

!PurchaseCartTest methodsFor: 'tests' stamp: 'fa 11/2/2023 19:34:24'!
test03sePuedenAgregarDosLibrosDiferentesAlCarrito

	| cart store |
	
	store := Dictionary new.
	cart := PurchaseCart forStore: store.
	
	store
		add: '1234'->3 ;
		add: '2345'->2 . 	
	cart 
		add: '1234' copies: 1 ;
		add: '2345' copies: 1 .

	self assert: (
		(cart size = 2) and: 
		(cart has: '1234') and: 
		(cart has: '2345')).
! !

!PurchaseCartTest methodsFor: 'tests' stamp: 'fa 11/2/2023 19:32:40'!
test04sePuedeAgregarVariasVecesElMismoLibro

	| cart store |
	
	store := Dictionary new.
	cart := PurchaseCart forStore: store.
	
	store
		add: '1234'->3 ;
		add: '2345'->2 . 	
		
	cart add: '1234' copies: 3 .

	self assert: (
		(cart size = 3) and: 
		((cart count: '1234') = 3)).
! !

!PurchaseCartTest methodsFor: 'tests' stamp: 'fa 11/2/2023 19:32:04'!
test05sePuedeAgregarVariasVecesVariosLibros

	| cart store |
	
	store := Dictionary new.
	cart := PurchaseCart forStore: store.
	
	store
		add: '1234'->3 ;
		add: '2345'->2 . 	
		
	cart  add: '1234' copies: 3 ;
		add: '2345' copies: 2 .

	self assert: (
		(cart size = 5) and: 
		((cart count: '1234') = 3) and: 
		((cart count: '2345') = 2)).
! !

!PurchaseCartTest methodsFor: 'tests' stamp: 'fa 11/2/2023 19:30:55'!
test06noSePuedeAgregarUnLibroQueNoEstaALaVenta

	| cart store |
	
	store := Dictionary new.
	store
		add: '1234'->1.	
	
	cart := PurchaseCart forStore: store.
	
	self 
		should: [ cart add: '1235' copies: 1 ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: PurchaseCart bookNotSoldAtStoreError . 
		].! !

!PurchaseCartTest methodsFor: 'tests' stamp: 'fa 11/2/2023 19:30:43'!
test07noSePuedeAgregarUnLibroQueNoTieneStock

	| cart store |
	
	store := Dictionary new.
	store
		add: '1234'->0.	
	
	cart := PurchaseCart forStore: store.
	
	self 
		should: [ cart add: '1234' copies: 1 ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: PurchaseCart bookOutOfStockError.
		].! !

!PurchaseCartTest methodsFor: 'tests' stamp: 'fa 11/2/2023 19:24:55'!
test08noSePuedeAgregarUnaCantidadMayorAlStockDisponible

	| cart store |
	
	store := Dictionary new.
	store
		add: '1234'->1.	
	
	cart := PurchaseCart forStore: store.
	
	self 
		should: [ cart add: '1234' copies: 2 ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: PurchaseCart notEnoughStockError. 
		].! !

!PurchaseCartTest methodsFor: 'tests' stamp: 'fa 11/2/2023 19:35:44'!
test09noSePuedeAgregarUnaCantidadNoPositivaDeLibros

	| cart store |
	
	store := Dictionary new.
	store
		add: '1234'->1.	
	
	cart := PurchaseCart forStore: store.
	
	self 
		should: [ cart add: '1234' copies: 0 ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: PurchaseCart bookQuantityShouldBePositiveError. 
		].! !


!classDefinition: #Cashier category: 'TusLibros'!
Object subclass: #Cashier
	instanceVariableNames: 'catalog'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'initializers' stamp: 'BK 11/5/2023 12:01:40'!
initializeWithCatalog: aCatalog

	catalog := aCatalog.! !


!Cashier methodsFor: 'error messages' stamp: 'BK 11/5/2023 12:12:08'!
cannotProcessEmptyCartError

	^ 'Cannot process empty cart.'! !

!Cashier methodsFor: 'error messages' stamp: 'BK 11/5/2023 12:42:46'!
itemNotInCatalogError

	^ 'Item not in catalog.'! !


!Cashier methodsFor: 'operators' stamp: 'BK 11/5/2023 12:45:33'!
process: aCart

	aCart isEmpty ifTrue: [ self error: self cannotProcessEmptyCartError ].
	
	^aCart contents sum: [ :anItem |
		catalog at: anItem
			ifAbsent: [ self error: self itemNotInCatalogError ]
	].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: 'TusLibros'!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'as yet unclassified' stamp: 'BK 11/5/2023 12:00:36'!
withCatalog: aCatalog

	^ Cashier new initializeWithCatalog: aCatalog.! !


!classDefinition: #HTTPRequester category: 'TusLibros'!
Object subclass: #HTTPRequester
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!HTTPRequester methodsFor: 'requests' stamp: 'fa 11/2/2023 20:07:08'!
post: request

	self subclassResponsibility.! !


!classDefinition: #MockHTTPRequester category: 'TusLibros'!
HTTPRequester subclass: #MockHTTPRequester
	instanceVariableNames: 'mockCode mockMessage'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!MockHTTPRequester methodsFor: 'mocking' stamp: 'fa 11/2/2023 23:41:33'!
post: aResquest

	^ OrderedCollection with: mockCode  with: mockMessage.! !

!MockHTTPRequester methodsFor: 'mocking' stamp: 'fa 11/2/2023 23:40:20'!
shouldResolveWithCode: aCodeNumber andMessage: aResolutionMessage

	mockCode := aCodeNumber.
	mockMessage := aResolutionMessage.! !


!MockHTTPRequester methodsFor: 'initialization' stamp: 'fa 11/2/2023 23:42:02'!
initialize

	mockCode := 200.
	mockMessage := '0|OK'.! !


!classDefinition: #NullHTTPRequester category: 'TusLibros'!
HTTPRequester subclass: #NullHTTPRequester
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!NullHTTPRequester methodsFor: 'requests' stamp: 'fa 11/2/2023 20:07:21'!
post: request

	"do nothing"! !


!classDefinition: #MerchantProcessorBridge category: 'TusLibros'!
Object subclass: #MerchantProcessorBridge
	instanceVariableNames: 'merchantHost httpRequester'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!MerchantProcessorBridge methodsFor: 'formatting' stamp: 'fa 11/2/2023 23:29:15'!
createQueryStringWithCCN: aCreditCardNumber expirationDate: anExpirationDate cardOwner: aCreditCardOwner andTransactionAmount: aTransactionAmount

	^ merchantHost, '?', 
		'creditCardNumber=', (self formatOrRejectCreditCardNumber: aCreditCardNumber), '&',
		'creditCardExpiration=', (self formatOrRejectCardExpirationDate: anExpirationDate), '&',
		'creditCardOwner=', (self formatOrRejectCreditCardOwner: aCreditCardOwner), '&',
		'transactionAmount=', (self formatOrRejectTransactionAmount: aTransactionAmount).! !

!MerchantProcessorBridge methodsFor: 'formatting' stamp: 'fa 11/3/2023 00:02:21'!
formatOrRejectCardExpirationDate: anExpirationDateString

	| month year |
	
	self assertExpirationDateStringHasSixCharacters: anExpirationDateString.
	self assertExpirationDateStringIsComposedOfDigitsOnly: anExpirationDateString.
	
	month := (anExpirationDateString copyFrom: 1 to: 2) asNumber.
	year := (anExpirationDateString  copyFrom: 3 to: 6) asNumber.
	
	self assertExpirationDateRepresentsValidMonth: month andYear: year.
	self assertCardHasNotExpiredForExpirationDateWithMonth: month andYear: year.
	
	^ anExpirationDateString.
	! !

!MerchantProcessorBridge methodsFor: 'formatting' stamp: 'fa 11/3/2023 00:03:28'!
formatOrRejectCreditCardNumber: aCreditCardNumberString

	self assertCardNumberStringIsOnlyNumeric: aCreditCardNumberString.
	
	^ aCreditCardNumberString.
! !

!MerchantProcessorBridge methodsFor: 'formatting' stamp: 'fa 11/3/2023 00:05:02'!
formatOrRejectCreditCardOwner: aCardOwnerString

	self assertCreditCardOwnerStringDoesNotExceed30Characters: aCardOwnerString.
	self assertCreditCardOwnerStringContainsOnlyAlphabeticOrSpaceCharacters: aCardOwnerString.
	
	^aCardOwnerString inject: '' into: [ :current :character | 
		character isAlphaNumeric 
			ifTrue: [current, (character asUppercase) asString ]
			ifFalse: [current, '%20'].
	].
! !

!MerchantProcessorBridge methodsFor: 'formatting' stamp: 'fa 11/3/2023 00:15:22'!
formatOrRejectTransactionAmount: aTransactionAmount
	
	| parts integerPart fractionPart |
	
	parts := self splitIntointegerAndFractionalParts: aTransactionAmount printString.
	integerPart := parts at: 1.
	fractionPart := parts at: 2.
	
	self assertIntegerPartOfTransactionAmountStringIsLessThanOrEqualToTheMaximumAllowed: integerPart.
	self assertFractionPartOfTransactionAmountStringIsLessThanOrEqualToTheMaximumAllowed: fractionPart .
	
	(fractionPart size = 0) ifTrue: [
		fractionPart := '00'.
	].
	(fractionPart size = 1) ifTrue: [
		fractionPart := fractionPart, '0'.
	].

	^ integerPart, '.', fractionPart.
! !

!MerchantProcessorBridge methodsFor: 'formatting' stamp: 'fa 11/3/2023 00:10:01'!
splitIntointegerAndFractionalParts: aTransactionAmountString
	
	| fractionPart integerPart dotSeen |
	
	fractionPart := ''.
	integerPart := ''.
	dotSeen := false.
	
	aTransactionAmountString do: [ :character | | isDot |
			isDot := character = $..
			dotSeen := dotSeen or: isDot.
			dotSeen
				ifFalse: [ integerPart := integerPart, character asString. ]
				ifTrue:  [ isDot ifFalse: [ fractionPart := fractionPart, character asString. ] ]
			].
	
	^ OrderedCollection with: integerPart with: fractionPart.! !


!MerchantProcessorBridge methodsFor: 'request' stamp: 'fa 11/2/2023 22:57:05'!
awaitResponseFor: request

	^httpRequester post: request.! !

!MerchantProcessorBridge methodsFor: 'request' stamp: 'fa 11/2/2023 23:27:44'!
processPaymentOf: aTransactionAmount forCardWithCCN: aCreditCardNumberString expirationDate: anExpirationDateString andOwner: aCardOwnerString
	
	^self awaitResponseFor: (self 
		createQueryStringWithCCN: aCreditCardNumberString
		expirationDate: anExpirationDateString
		cardOwner: aCardOwnerString
		andTransactionAmount: aTransactionAmount).
! !


!MerchantProcessorBridge methodsFor: 'assertions' stamp: 'fa 11/3/2023 00:15:41'!
assertCardHasNotExpiredForExpirationDateWithMonth: month andYear: year

	((Date newDay: 1 month: month year: year) <  Date today) ifTrue: [
		self error: self class invalidExpirationDateError.
	]! !

!MerchantProcessorBridge methodsFor: 'assertions' stamp: 'fa 11/3/2023 00:15:47'!
assertCardNumberStringIsOnlyNumeric: aCreditCardNumberString

	(aCreditCardNumberString anySatisfy: [ :character | (character isDigit) not ]) ifTrue: [
		self error: self class invalidCreditCardNumberError.	
	]! !

!MerchantProcessorBridge methodsFor: 'assertions' stamp: 'fa 11/3/2023 00:15:51'!
assertCreditCardOwnerStringContainsOnlyAlphabeticOrSpaceCharacters: aCardOwnerString

	(aCardOwnerString anySatisfy: [ :character | ('abcdefghijklmnopqrstuvwxyz ' includes: character asLowercase) not]) ifTrue: [
		self error: self class invalidCreditCardOwnerError.	
	]! !

!MerchantProcessorBridge methodsFor: 'assertions' stamp: 'fa 11/3/2023 00:15:55'!
assertCreditCardOwnerStringDoesNotExceed30Characters: aCardOwnerString

	(aCardOwnerString size > 30) ifTrue: [
		self error: self class invalidCreditCardOwnerError.	
	]! !

!MerchantProcessorBridge methodsFor: 'assertions' stamp: 'fa 11/2/2023 23:57:51'!
assertExpirationDateRepresentsValidMonth: aMonth andYear: anYear

	(0 < aMonth and: aMonth < 13) ifFalse: [
		self error: self class invalidExpirationDateError.
	].
	(2000 < anYear and: anYear < 3000) ifFalse: [
		self error: self class invalidExpirationDateError.
	]! !

!MerchantProcessorBridge methodsFor: 'assertions' stamp: 'fa 11/3/2023 00:16:07'!
assertExpirationDateStringHasSixCharacters: anExpirationDateString

	(anExpirationDateString size = 6) ifFalse: [
		self error: self class invalidExpirationDateError.	
	]! !

!MerchantProcessorBridge methodsFor: 'assertions' stamp: 'fa 11/3/2023 00:16:21'!
assertExpirationDateStringIsComposedOfDigitsOnly: anExpirationDateString

	(anExpirationDateString anySatisfy: [ :character | character isDigit not ]) ifTrue: [
		self error: self class invalidExpirationDateError.	
	]! !

!MerchantProcessorBridge methodsFor: 'assertions' stamp: 'fa 11/3/2023 00:16:25'!
assertFractionPartOfTransactionAmountStringIsLessThanOrEqualToTheMaximumAllowed: aTransactionAmount

	(aTransactionAmount size > 2) ifTrue: [
		self error: self class invalidTransactionAmountError.
	]! !

!MerchantProcessorBridge methodsFor: 'assertions' stamp: 'fa 11/3/2023 00:16:29'!
assertIntegerPartOfTransactionAmountStringIsLessThanOrEqualToTheMaximumAllowed: aTransactionAmount

	(aTransactionAmount size > 15) ifTrue: [
		self error: self class invalidTransactionAmountError.
	]! !


!MerchantProcessorBridge methodsFor: 'initialization' stamp: 'fa 11/2/2023 20:13:03'!
initializeWith: anHTTPRequester forMerchantHost: aHost

	httpRequester := anHTTPRequester.
	merchantHost := aHost.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MerchantProcessorBridge class' category: 'TusLibros'!
MerchantProcessorBridge class
	instanceVariableNames: ''!

!MerchantProcessorBridge class methodsFor: 'error messages' stamp: 'fa 11/2/2023 20:20:24'!
invalidCreditCardNumberError

	^ 'provided credit card is not valid'.! !

!MerchantProcessorBridge class methodsFor: 'error messages' stamp: 'fa 11/2/2023 20:36:41'!
invalidCreditCardOwnerError

	^ 'provided credit card owner is not valid'.! !

!MerchantProcessorBridge class methodsFor: 'error messages' stamp: 'fa 11/2/2023 20:34:49'!
invalidExpirationDateError

	^ 'provided credit card expiration date is not valid'.! !

!MerchantProcessorBridge class methodsFor: 'error messages' stamp: 'fa 11/2/2023 20:57:23'!
invalidTransactionAmountError

	^ 'provided transaction amount is not valid (too big or with more than two digits precision)'.! !


!MerchantProcessorBridge class methodsFor: 'instance creation' stamp: 'fa 11/2/2023 21:06:12'!
with: anHTTPRequester forMerchantHost: aHost.

	^self new initializeWith: anHTTPRequester forMerchantHost: aHost.! !


!classDefinition: #PurchaseCart category: 'TusLibros'!
Object subclass: #PurchaseCart
	instanceVariableNames: 'contents storeReference'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!PurchaseCart methodsFor: 'testing' stamp: 'fa 11/2/2023 18:53:05'!
count: aBook

	^ contents occurrencesOf: aBook.! !

!PurchaseCart methodsFor: 'testing' stamp: 'fa 11/2/2023 18:50:22'!
has: aBook

	^ contents includes: aBook.! !

!PurchaseCart methodsFor: 'testing' stamp: 'fa 11/2/2023 18:43:15'!
isEmpty

	^ contents isEmpty.! !

!PurchaseCart methodsFor: 'testing' stamp: 'fa 11/2/2023 18:48:43'!
size

	^ contents size.! !


!PurchaseCart methodsFor: 'operation' stamp: 'fa 11/2/2023 19:40:00'!
add: aBook copies: aQuantity

	| stock |
	
	(aQuantity < 1) ifTrue: [ self error: self class bookQuantityShouldBePositiveError. ].
	
	stock := storeReference at: aBook ifAbsent: -1.
	(stock = -1) ifTrue: [ self error: self class bookNotSoldAtStoreError.].
	(stock = 0)    ifTrue: [ self error: self class bookOutOfStockError.].
	(stock < aQuantity) ifTrue: [ self error: self class notEnoughStockError. ].
	
	contents add: aBook withOccurrences: aQuantity.
! !

!PurchaseCart methodsFor: 'operation' stamp: 'BK 11/5/2023 12:04:08'!
contents 

	^ contents.! !


!PurchaseCart methodsFor: 'initialization' stamp: 'fa 11/2/2023 18:43:28'!
initialize

	contents := Bag new.! !

!PurchaseCart methodsFor: 'initialization' stamp: 'fa 11/2/2023 19:15:33'!
initializeWith: aStoreDictionary

	storeReference := aStoreDictionary.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PurchaseCart class' category: 'TusLibros'!
PurchaseCart class
	instanceVariableNames: ''!

!PurchaseCart class methodsFor: 'error messages' stamp: 'fa 11/2/2023 19:28:40'!
bookNotSoldAtStoreError

	^ 'store does not sell the requested book'.! !

!PurchaseCart class methodsFor: 'error messages' stamp: 'fa 11/2/2023 19:29:11'!
bookOutOfStockError

	^ 'store does not have stock for the requested book'.! !

!PurchaseCart class methodsFor: 'error messages' stamp: 'fa 11/2/2023 19:36:39'!
bookQuantityShouldBePositiveError

	^ 'must add at least one copy of the requested book'.! !

!PurchaseCart class methodsFor: 'error messages' stamp: 'fa 11/2/2023 19:29:40'!
notEnoughStockError

	^ 'store does not have enough stock available'.! !


!PurchaseCart class methodsFor: 'instance creation' stamp: 'fa 11/2/2023 19:24:02'!
forStore: aStoreDictionary

	^self new initializeWith: aStoreDictionary.! !
