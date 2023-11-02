!classDefinition: #TusLibrosRESTTest category: 'TusLibros'!
TestCase subclass: #TusLibrosRESTTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!TusLibrosRESTTest methodsFor: 'tests-createCart' stamp: 'BK 11/2/2023 15:37:45'!
test01noSePuedeCrearUnCarritoSiElUsuarioNoExiste

	| response api users |
	
	users := UserDatabase with: (Dictionary new). 
	api := TusLibrosREST new withUsers: users.
	
	response := api receiveRequest: '/createCart?userId=BK&userPassword=unaContraseña'.
	
	"response := api createCartForClientWithId: 'BK' andPassword: 'unaContraseña'."
	
	self assert: response = '1|El usuario no existe.'
! !

!TusLibrosRESTTest methodsFor: 'tests-createCart' stamp: 'fa 11/1/2023 20:07:06'!
test02noSePuedeCrearUnCarritoSiLaContraseñaDelUsuarioEsIncorrecta

	| response api db |
	
	db := UserDatabase with: (Dictionary add: 'Fede'->'poiuytrewq'). 
	api := TusLibrosREST withDatabase: db.
	response := api createCartForClientWithId: 'Fede' andPassword: 'password'.
	
	self assert: (response at: 1) = '1'.
	self assert: (response at: 2) = UserDatabase userPasswordIsIncorrectError. ! !

!TusLibrosRESTTest methodsFor: 'tests-createCart' stamp: 'fa 11/1/2023 20:08:31'!
test03sePuedeCrearUnCarritoConCredencialesValidas

	| response db api |
	
	db := UserDatabase with: (Dictionary add: 'Fede'->'poiuytrewq'). 
	api := TusLibrosREST withDatabase: db.
	response := api createCartForClientWithId: 'Fede' andPassword: 'poiuytrewq'.
	
	self assert: (response at: 1) = '0'.
	self assert: (response at: 2) size > 0.! !

!TusLibrosRESTTest methodsFor: 'tests-createCart' stamp: 'fa 11/1/2023 20:12:40'!
test04unCarritoCreadoRealmenteExiste

	| response db api |
	
	db := UserDatabase with: (Dictionary add: 'Fede'->'poiuytrewq'). 
	api := TusLibrosREST withDatabase: db.
	response := api createCartForClientWithId: 'Fede' andPassword: 'poiuytrewq'.
	
	self assert: (response at: 1) = '0'.
	self assert: (api cartIsValid: (response at: 2)).! !

!TusLibrosRESTTest methodsFor: 'tests-createCart' stamp: 'fa 11/1/2023 20:21:31'!
test05unCarritoNuevoEstaVacio! !

!TusLibrosRESTTest methodsFor: 'tests-createCart' stamp: 'BK 11/2/2023 13:37:07'!
test06unCarritoNuevoNoVaAExpirarEnLosSiguientesTreintaMinutos

	| response db api |
	
	db := UserDatabase with: (Dictionary add: 'Fede'->'poiuytrewq'). 
	api := TusLibrosREST withDatabase: db.
	response := api createCartForClientWithId: 'Fede' andPassword: 'poiuytrewq'.
	
	(Delay forSeconds: 29) wait.
	
	self assert: (api existsCartWithID: (response at: 2)).
	
	(Delay forSeconds: 1) wait.
	
	self assert: (api existsCartWithID: (response at: 2)) not.! !

!TusLibrosRESTTest methodsFor: 'tests-createCart' stamp: 'fa 11/1/2023 21:01:05'!
test07unRequestInvalidoDeCreateCartRetornaBadRequest
! !


!TusLibrosRESTTest methodsFor: 'tests-addToCart' stamp: 'BK 11/2/2023 13:50:47'!
test01noSePuedeAgregarUnLibroConISBNinvalido

	| response db isbns api |
	
	db := UserDatabase with: (Dictionary add: 'Fede'->'poiuytrewq'). 
	isbns := ISBNDatabase new.
	api := TusLibrosREST withDatabase: db andValidISBNs: isbns.
	response := api createCartForClientWithId: 'Fede' andPassword: 'poiuytrewq'.
	
	response := api
		addToCartWithID: (response at: 1)
		theBookWithISBN: '1234'
		withQuantity: 1.
	
	self assert: (response at: 1) = '1'.
	self assert: (response at: 2) = ISBNDatabase invalidISBNError.! !

!TusLibrosRESTTest methodsFor: 'tests-addToCart' stamp: 'BK 11/2/2023 13:53:44'!
test02noSePuedeAgregarAUnCarritoInvalido

	| response db api isbns |
	
	db := UserDatabase with: (Dictionary add: 'Fede'->'poiuytrewq'). 
	isbns := ISBNDatabase with: (OrderedCollection with: '1234').
	api := TusLibrosREST withDatabase: db andValidISBNs: isbns.
	response := api createCartForClientWithId: 'Fede' andPassword: 'poiuytrewq'.
	
	response := api
		addToCartWithID: (response at: 1) + 1
		theBookWithISBN: '1234'
		withQuantity: 1.
	
	self assert: (response at: 1) = '1'.
	self assert: (response at: 2) = TusLibrosREST invalidCartIDError.! !

!TusLibrosRESTTest methodsFor: 'tests-addToCart' stamp: 'BK 11/2/2023 13:53:47'!
test03noSePuedeAgregarUnaCantidadDeLibrosMenorAUno

	| response db isbns api |
	
	db := UserDatabase with: (Dictionary add: 'Fede'->'poiuytrewq'). 
	isbns := ISBNDatabase with: (OrderedCollection with: '1234').
	api := TusLibrosREST withDatabase: db andValidISBNs: isbns.
	response := api createCartForClientWithId: 'Fede' andPassword: 'poiuytrewq'.
	
	response := api
		addToCartWithID: (response at: 1)
		theBookWithISBN: '1234'
		withQuantity: 0.
	
	self assert: (response at: 1) = '1'.
	self assert: (response at: 2) = TusLibrosREST invalidadBookQuantityError.! !

!TusLibrosRESTTest methodsFor: 'tests-addToCart' stamp: 'BK 11/2/2023 13:53:56'!
test04sePuedeAgregarUnLibroDeLaEditorialAUnCarritoValido

	
	| response db isbns api |
	
	db := UserDatabase with: (Dictionary add: 'Fede'->'poiuytrewq'). 
	isbns := ISBNDatabase with: (OrderedCollection with: '1234').
	api := TusLibrosREST withDatabase: db andValidISBNs: isbns.
	response := api createCartForClientWithId: 'Fede' andPassword: 'poiuytrewq'.
	
	response := api
		addToCartWithID: (response at: 1)
		theBookWithISBN: '1234'
		withQuantity: 1.
	
	self assert: (response at: 1) = '0'.
	self assert: (response at: 2) = 'OK'.! !

!TusLibrosRESTTest methodsFor: 'tests-addToCart' stamp: 'BK 11/2/2023 13:54:46'!
test05sePuedeAgregarMasDeUnLibroDeLaEditorialAUnCarritoValido

	| cartId response db isbns api |
	
	db := UserDatabase with: (Dictionary add: 'Fede'->'poiuytrewq'). 
	isbns := ISBNDatabase with: (OrderedCollection with: '1234' with: '4321').
	api := TusLibrosREST withDatabase: db andValidISBNs: isbns.
	cartId := api createCartForClientWithId: 'Fede' andPassword: 'poiuytrewq'.
	
	response := api
		addToCartWithID: (cartId at: 1)
		theBookWithISBN: '1234'
		withQuantity: 1.
	
	self assert: (response at: 1) = '0'.
	self assert: (response at: 2) = 'OK'.
	
	response := api
		addToCartWithID: (cartId at: 1)
		theBookWithISBN: '4321'
		withQuantity: 2.
	
	self assert: (response at: 1) = '0'.
	self assert: (response at: 2) = 'OK'.! !

!TusLibrosRESTTest methodsFor: 'tests-addToCart' stamp: 'fa 11/1/2023 20:25:53'!
test06noSePuedeAgregarLibrosAUnCarritoQueYaExpiro! !

!TusLibrosRESTTest methodsFor: 'tests-addToCart' stamp: 'BK 11/2/2023 14:00:05'!
test07agregarUnLibroQueYaEstaEnElCarritoLeSumaLaCantidad

	
	| cartId db isbns api |
	
	db := UserDatabase with: (Dictionary add: 'Fede'->'poiuytrewq'). 
	isbns := ISBNDatabase with: (OrderedCollection with: '1234' with: '4321').
	api := TusLibrosREST withDatabase: db andValidISBNs: isbns.
	cartId := api createCartForClientWithId: 'Fede' andPassword: 'poiuytrewq'.
	
	api
		addToCartWithID: (cartId at: 1)
		theBookWithISBN: '1234'
		withQuantity: 1.
	
	api
		addToCartWithID: (cartId at: 1)
		theBookWithISBN: '1234'
		withQuantity: 1.
	
	self assert: (api books at: '1234') = 2.! !

!TusLibrosRESTTest methodsFor: 'tests-addToCart' stamp: 'fa 11/1/2023 21:00:52'!
test08unRequestInvalidoDeAddToCartRetornaBadRequest
! !


!TusLibrosRESTTest methodsFor: 'tests-checkOutCart' stamp: 'BK 11/2/2023 14:13:50'!
test01noSePuedeHacerCheckoutConUnCarritoQueNoExiste

	| response cartId api db |
	
	MerchantProcessorStub
		addCardWithCCN: '0000111122223333'
		andCCED: '072011'
		andCCO: 'FEDERICO ARIENTI'	.
	
	db := UserDatabase with: (Dictionary add: 'Fede'->'poiuytrewq'). 
	api := TusLibrosREST withDatabase: db.
	cartId := api createCartForClientWithId: 'Fede' andPassword: 'password'.
	
	response := api
		checkoutCartWithID: cartId + 1
		ccn: '0000111122223333'
		cced: '072011'
		cco: 'FEDERICO ARIENTI'.
		
	self assert: (response at: 1) = '1'.
	self assert: (response at: 2) = TusLibrosREST invalidCartIDError.
! !

!TusLibrosRESTTest methodsFor: 'tests-checkOutCart' stamp: 'BK 11/2/2023 14:13:55'!
test02hacerCheckoutConUnaTarjetaInvalidaRetornaUnError

	| response cartId api db |
	
	MerchantProcessorStub
		addCardWithCCN: '0000111122223333'
		andCCED: '072011'
		andCCO: 'FEDERICO ARIENTI'	.
	
	db := UserDatabase with: (Dictionary add: 'Fede'->'poiuytrewq'). 
	api := TusLibrosREST withDatabase: db.
	cartId := api createCartForClientWithId: 'Fede' andPassword: 'password'.
	
	response := api
		checkoutCartWithID: cartId
		ccn: '0000000000000000'
		cced: '000000'
		cco: 'NAPOLEON BONAPARTE'.
		
	self assert: (response at: 1) = '1'.
	self assert: (response at: 2) = MerchantProcessorStub invalidCardError.
! !

!TusLibrosRESTTest methodsFor: 'tests-checkOutCart' stamp: 'BK 11/2/2023 15:26:22'!
test02noSePuedeHacerCheckoutConUnCarritoQueYaExpiro

	| response cartId api db |
	
	MerchantProcessorStub
		addCardWithCCN: '0000111122223333'
		andCCED: '072011'
		andCCO: 'FEDERICO ARIENTI'	.
	
	db := UserDatabase with: (Dictionary add: 'Fede'->'poiuytrewq'). 
	api := TusLibrosREST withDatabase: db.
	cartId := api createCartForClientWithId: 'Fede' andPassword: 'password'.
	 
	(Delay forSeconds: 30) wait.
	
	response := api
		checkoutCartWithID: cartId + 1
		ccn: '0000111122223333'
		cced: '072011'
		cco: 'FEDERICO ARIENTI'.
		
	self assert: (response at: 1) = '1'.
	self assert: (response at: 2) = TusLibrosREST invalidCartIDError.
! !

!TusLibrosRESTTest methodsFor: 'tests-checkOutCart' stamp: 'BK 11/2/2023 14:06:29'!
test03seComputaCorrectamenteElValorADebitarPorElCarrito
! !

!TusLibrosRESTTest methodsFor: 'tests-checkOutCart' stamp: 'BK 11/2/2023 14:14:07'!
test04hacerCheckoutConUnaTarjetaValidaRespondeConExito

	| response cartId api db |
	
	MerchantProcessorStub
		addCardWithCCN: '0000111122223333'
		andCCED: '072011'
		andCCO: 'FEDERICO ARIENTI'	.
	
	db := UserDatabase with: (Dictionary add: 'Fede'->'poiuytrewq'). 
	api := TusLibrosREST withDatabase: db.
	cartId := api createCartForClientWithId: 'Fede' andPassword: 'password'.
	
	response := api
		checkoutCartWithID: cartId
		ccn: '0000000000000000'
		cced: '000000'
		cco: 'NAPOLEON BONAPARTE'.
		
	self assert: (response at: 1) = '0'.
	self assert: (response at: 2) size > 0.! !

!TusLibrosRESTTest methodsFor: 'tests-checkOutCart' stamp: 'BK 11/2/2023 14:06:37'!
test05unCheckoutValidoRetornaUnNumeroDeTransaccionValido
! !

!TusLibrosRESTTest methodsFor: 'tests-checkOutCart' stamp: 'BK 11/2/2023 14:06:41'!
test06siMerchantProcessorEstaCaidoSeGuardaElPedidoCorrectamente
! !

!TusLibrosRESTTest methodsFor: 'tests-checkOutCart' stamp: 'BK 11/2/2023 14:06:45'!
test07unRequestInvalidoDeCheckOutCartRetornaBadRequest
! !


!TusLibrosRESTTest methodsFor: 'tests-listPurchases' stamp: 'fa 11/1/2023 20:49:14'!
test01noSePuedenListarComprasDeUnClienteQueNoExiste! !

!TusLibrosRESTTest methodsFor: 'tests-listPurchases' stamp: 'fa 11/1/2023 20:49:57'!
test02noSePuedenListarComprasDeUnClienteSiLaContraseñaEsInvalida! !

!TusLibrosRESTTest methodsFor: 'tests-listPurchases' stamp: 'fa 11/1/2023 20:51:15'!
test03seListanLasComprasDeUnUsuarioConCredencialesValidas! !

!TusLibrosRESTTest methodsFor: 'tests-listPurchases' stamp: 'fa 11/1/2023 20:53:19'!
test04seListanCeroComprasParaUnUsuarioSinCompras! !

!TusLibrosRESTTest methodsFor: 'tests-listPurchases' stamp: 'fa 11/1/2023 20:53:46'!
test05unaTransaccionApareceListadaDespuesDeConcretarse! !

!TusLibrosRESTTest methodsFor: 'tests-listPurchases' stamp: 'fa 11/1/2023 20:54:43'!
test06todasLasTransaccionesRealizadasAparecenListadas! !

!TusLibrosRESTTest methodsFor: 'tests-listPurchases' stamp: 'fa 11/1/2023 20:57:52'!
test07todasLasTransaccionesRealizadasAparecenListadasConLaCantidadCorrecta
! !

!TusLibrosRESTTest methodsFor: 'tests-listPurchases' stamp: 'fa 11/1/2023 20:59:12'!
test08unRequestInvalidoDeListPurchasesRetornaBadRequest
! !


!TusLibrosRESTTest methodsFor: 'tests-listCart' stamp: 'fa 11/1/2023 20:30:01'!
test01noSePuedeListarUnCarritoQueNoExiste

! !

!TusLibrosRESTTest methodsFor: 'tests-listCart' stamp: 'fa 11/1/2023 20:30:08'!
test02noSePuedeListarUnCarritoQueExpiro
! !

!TusLibrosRESTTest methodsFor: 'tests-listCart' stamp: 'fa 11/1/2023 20:30:35'!
test03seListaUnCarritoValidoVacio
! !

!TusLibrosRESTTest methodsFor: 'tests-listCart' stamp: 'fa 11/1/2023 20:30:54'!
test04seListaUnCarritoValidoConUnLibro
! !

!TusLibrosRESTTest methodsFor: 'tests-listCart' stamp: 'fa 11/1/2023 20:31:01'!
test05seListaUnCarritoValidoConMuchosLibros
! !

!TusLibrosRESTTest methodsFor: 'tests-listCart' stamp: 'fa 11/1/2023 20:58:48'!
test06unRequestInvalidoDeListCartRetornaBadRequest

! !


!classDefinition: #Carrito category: 'TusLibros'!
Object subclass: #Carrito
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!


!classDefinition: #ISBNDatabase category: 'TusLibros'!
Object subclass: #ISBNDatabase
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!


!classDefinition: #Libro category: 'TusLibros'!
Object subclass: #Libro
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!


!classDefinition: #MerchantProcessorStub category: 'TusLibros'!
Object subclass: #MerchantProcessorStub
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!


!classDefinition: #TusLibrosREST category: 'TusLibros'!
Object subclass: #TusLibrosREST
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!


!classDefinition: #UserDatabase category: 'TusLibros'!
Object subclass: #UserDatabase
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!
