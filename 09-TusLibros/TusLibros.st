!classDefinition: #TusLibrosRESTTest category: 'TusLibros'!
TestCase subclass: #TusLibrosRESTTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!TusLibrosRESTTest methodsFor: 'tests-createCart' stamp: 'fa 11/1/2023 20:05:21'!
test01noSePuedeCrearUnCarritoSiElUsuarioNoExiste

	| response api db |
	
	db := UserDatabase with: (Dictionary new). 
	api := TusLibrosREST withDatabase: db.
	response := api createCartForClientWithId: 'BK' andPassword: 'unaContraseña'.
	
	self assert: (response at: 1) = '1'.
	self assert: (response at: 2) = UserDatabase userDoesNotExistError. 
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

!TusLibrosRESTTest methodsFor: 'tests-createCart' stamp: 'fa 11/1/2023 20:22:14'!
test06unCarritoNuevoNoVaAExpirarEnLosSiguientesTreintaMinutos! !

!TusLibrosRESTTest methodsFor: 'tests-createCart' stamp: 'fa 11/1/2023 21:01:05'!
test07unRequestInvalidoDeCreateCartRetornaBadRequest
! !


!TusLibrosRESTTest methodsFor: 'tests-addToCart' stamp: 'fa 11/1/2023 20:24:59'!
test01noSePuedeAgregarUnLibroConISBNinvalido
! !

!TusLibrosRESTTest methodsFor: 'tests-addToCart' stamp: 'fa 11/1/2023 20:25:09'!
test02noSePuedeAgregarAUnCarritoInvalido
! !

!TusLibrosRESTTest methodsFor: 'tests-addToCart' stamp: 'fa 11/1/2023 20:25:17'!
test03noSePuedeAgregarUnaCantidadDeLibrosMenorAUno
! !

!TusLibrosRESTTest methodsFor: 'tests-addToCart' stamp: 'fa 11/1/2023 20:26:06'!
test04sePuedeAgregarUnLibroDeLaEditorialAUnCarritoValido
! !

!TusLibrosRESTTest methodsFor: 'tests-addToCart' stamp: 'fa 11/1/2023 20:25:37'!
test05sePuedeAgregarMasDeUnLibroDeLaEditorialAUnCarritoValido! !

!TusLibrosRESTTest methodsFor: 'tests-addToCart' stamp: 'fa 11/1/2023 20:25:53'!
test06noSePuedeAgregarLibrosAUnCarritoQueYaExpiro! !

!TusLibrosRESTTest methodsFor: 'tests-addToCart' stamp: 'fa 11/1/2023 20:45:54'!
test07agregarUnLibroQueYaEstaEnElCarritoLeSumaLaCantidad! !

!TusLibrosRESTTest methodsFor: 'tests-addToCart' stamp: 'fa 11/1/2023 21:00:52'!
test08unRequestInvalidoDeAddToCartRetornaBadRequest
! !


!TusLibrosRESTTest methodsFor: 'tests-checkOutCart' stamp: 'fa 11/1/2023 20:34:31'!
test01noSePuedeHacerCheckoutConUnCarritoQueNoExiste! !

!TusLibrosRESTTest methodsFor: 'tests-checkOutCart' stamp: 'fa 11/1/2023 20:34:39'!
test02noSePuedeHacerCheckoutConUnCarritoQueExpiro
! !

!TusLibrosRESTTest methodsFor: 'tests-checkOutCart' stamp: 'fa 11/1/2023 20:37:17'!
test03hacerCheckoutConUnaTarjetaInvalidaRetornaUnError
! !

!TusLibrosRESTTest methodsFor: 'tests-checkOutCart' stamp: 'fa 11/1/2023 20:38:33'!
test04seComputaCorrectamenteElValorADebitarPorElCarrito
! !

!TusLibrosRESTTest methodsFor: 'tests-checkOutCart' stamp: 'fa 11/1/2023 20:40:05'!
test05hacerCheckoutConUnaTarjetaValidaRespondeConExito
! !

!TusLibrosRESTTest methodsFor: 'tests-checkOutCart' stamp: 'fa 11/1/2023 20:41:42'!
test06unCheckoutValidoRetornaUnNumeroDeTransaccionValido
! !

!TusLibrosRESTTest methodsFor: 'tests-checkOutCart' stamp: 'fa 11/1/2023 20:47:56'!
test07siMerchantProcessorEstaCaidoSeGuardaElPedidoCorrectamente
! !

!TusLibrosRESTTest methodsFor: 'tests-checkOutCart' stamp: 'fa 11/1/2023 20:59:32'!
test08unRequestInvalidoDeCheckOutCartRetornaBadRequest
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
