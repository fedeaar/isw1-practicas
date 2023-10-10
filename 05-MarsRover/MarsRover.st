!classDefinition: #MarsRoverTest category: 'MarsRover'!
TestCase subclass: #MarsRoverTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!MarsRoverTest methodsFor: 'Tests' stamp: 'BK 10/10/2023 18:58:17'!
test01usaDireccionValida
	
	self
		should: [MarsRover at: 0@0 towards: 'K'.]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText = MarsRover invalidDirection ].! !

!MarsRoverTest methodsFor: 'Tests' stamp: 'BK 10/10/2023 19:57:11'!
test02noSeMueveSinComandos
	
	self
		assertRoverAt: 0@0
		pointingTowards: 'N'
		willMoveTo: 0@0
		andPointTowards: 'N'
		afterReceiving: ''! !

!MarsRoverTest methodsFor: 'Tests' stamp: 'BK 10/10/2023 19:57:17'!
test03adelanteCuandoApuntaAlNorte
	
	self
		assertRoverAt: 0@0
		pointingTowards: 'N'
		willMoveTo: 0@1
		andPointTowards: 'N'
		afterReceiving: 'f'! !

!MarsRoverTest methodsFor: 'Tests' stamp: 'BK 10/10/2023 19:57:20'!
test04adelanteCuandoApuntaAlEste
	
	self
		assertRoverAt: 0@0
		pointingTowards: 'E'
		willMoveTo: 1@0
		andPointTowards: 'E'
		afterReceiving: 'f'! !

!MarsRoverTest methodsFor: 'Tests' stamp: 'BK 10/10/2023 19:57:23'!
test05adelanteCuandoApuntaAlOeste
	
	self
		assertRoverAt: 0@0
		pointingTowards: 'W'
		willMoveTo: -1@0
		andPointTowards: 'W'
		afterReceiving: 'f'! !

!MarsRoverTest methodsFor: 'Tests' stamp: 'BK 10/10/2023 19:57:26'!
test06adelanteCuandoApuntaAlSur
	
	self
		assertRoverAt: 0@0
		pointingTowards: 'S'
		willMoveTo: 0@-1
		andPointTowards: 'S'
		afterReceiving: 'f'! !

!MarsRoverTest methodsFor: 'Tests' stamp: 'BK 10/10/2023 19:57:29'!
test07atrasCuandoApuntaAlNorte
	
	self
		assertRoverAt: 0@0
		pointingTowards: 'N'
		willMoveTo: 0@-1
		andPointTowards: 'N'
		afterReceiving: 'b'! !

!MarsRoverTest methodsFor: 'Tests' stamp: 'BK 10/10/2023 19:57:33'!
test08atrasCuandoApuntaAlEste
	
	self
		assertRoverAt: 0@0
		pointingTowards: 'E'
		willMoveTo: -1@0
		andPointTowards: 'E'
		afterReceiving: 'b'! !

!MarsRoverTest methodsFor: 'Tests' stamp: 'BK 10/10/2023 19:57:36'!
test09atrasCuandoApuntaAlOeste
	
	self
		assertRoverAt: 0@0
		pointingTowards: 'W'
		willMoveTo: 1@0
		andPointTowards: 'W'
		afterReceiving: 'b'! !

!MarsRoverTest methodsFor: 'Tests' stamp: 'BK 10/10/2023 19:57:39'!
test10atrasCuandoApuntaAlSur
	
	self
		assertRoverAt: 0@0
		pointingTowards: 'S'
		willMoveTo: 0@1
		andPointTowards: 'S'
		afterReceiving: 'b'! !

!MarsRoverTest methodsFor: 'Tests' stamp: 'BK 10/10/2023 19:57:43'!
test11izquierdaCuandoApuntaAlNorte
	
	self
		assertRoverAt: 0@0
		pointingTowards: 'N'
		willMoveTo: 0@0
		andPointTowards: 'W'
		afterReceiving: 'l'! !

!MarsRoverTest methodsFor: 'Tests' stamp: 'BK 10/10/2023 19:57:46'!
test12izquierdaCuandoApuntaAlEste
	
	self
		assertRoverAt: 0@0
		pointingTowards: 'E'
		willMoveTo: 0@0
		andPointTowards: 'N'
		afterReceiving: 'l'! !

!MarsRoverTest methodsFor: 'Tests' stamp: 'BK 10/10/2023 19:57:50'!
test13izquierdaCuandoApuntaAlOeste
	
	self
		assertRoverAt: 0@0
		pointingTowards: 'W'
		willMoveTo: 0@0
		andPointTowards: 'S'
		afterReceiving: 'l'! !

!MarsRoverTest methodsFor: 'Tests' stamp: 'BK 10/10/2023 19:57:54'!
test14izquierdaCuandoApuntaAlSur
	
	self
		assertRoverAt: 0@0
		pointingTowards: 'S'
		willMoveTo: 0@0
		andPointTowards: 'E'
		afterReceiving: 'l'! !

!MarsRoverTest methodsFor: 'Tests' stamp: 'BK 10/10/2023 19:57:57'!
test15derechaCuandoApuntaAlNorte
	
	self
		assertRoverAt: 0@0
		pointingTowards: 'N'
		willMoveTo: 0@0
		andPointTowards: 'E'
		afterReceiving: 'r'! !

!MarsRoverTest methodsFor: 'Tests' stamp: 'BK 10/10/2023 19:58:00'!
test16derechaCuandoApuntaAlEste
	
	self
		assertRoverAt: 0@0
		pointingTowards: 'E'
		willMoveTo: 0@0
		andPointTowards: 'S'
		afterReceiving: 'r'! !

!MarsRoverTest methodsFor: 'Tests' stamp: 'BK 10/10/2023 19:58:03'!
test17derechaCuandoApuntaAlOeste
	
	self
		assertRoverAt: 0@0
		pointingTowards: 'W'
		willMoveTo: 0@0
		andPointTowards: 'N'
		afterReceiving: 'r'! !

!MarsRoverTest methodsFor: 'Tests' stamp: 'BK 10/10/2023 19:58:08'!
test18derechaCuandoApuntaAlSur
	
	self
		assertRoverAt: 0@0
		pointingTowards: 'S'
		willMoveTo: 0@0
		andPointTowards: 'W'
		afterReceiving: 'r'! !

!MarsRoverTest methodsFor: 'Tests' stamp: 'BK 10/10/2023 19:58:11'!
test19elRoverBailaEnElLugar
	
	self
		assertRoverAt: 0@0
		pointingTowards: 'N'
		willMoveTo: 0@0
		andPointTowards: 'N'
		afterReceiving: 'rrrlrrrlrrrlfbfbrr'! !

!MarsRoverTest methodsFor: 'Tests' stamp: 'BK 10/10/2023 19:42:39'!
test20comandoInvalido

	| rover |
	
	rover := MarsRover at: 0@0 towards: 'N'.

	self
		should: [rover receive: 'fxf'. ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: (anError messageText = MarsRover invalidCommand
			and: rover location = (0@1)) ].! !


!MarsRoverTest methodsFor: 'Auxiliares' stamp: 'BK 10/10/2023 19:48:20'!
assertRoverAt: aLocation pointingTowards: aDirection willMoveTo: aNewLocation andPointTowards: aNewDirection afterReceiving: commands

	| rover |
	
	rover := MarsRover at: aLocation towards: aDirection.
	
	rover receive: commands.
	
	self assert: (rover location = aNewLocation and: rover direction = aNewDirection).! !


!classDefinition: #MarsRover category: 'MarsRover'!
Object subclass: #MarsRover
	instanceVariableNames: 'location direction'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!MarsRover methodsFor: 'Observadores' stamp: 'BK 10/10/2023 18:44:57'!
direction

	^ direction! !

!MarsRover methodsFor: 'Observadores' stamp: 'BK 10/10/2023 18:44:52'!
location

	^ location! !


!MarsRover methodsFor: 'Inicializadores' stamp: 'BK 10/10/2023 18:44:27'!
initializeAt: aLocation towards: aDirection

	location := aLocation.
	direction := aDirection.

	! !


!MarsRover methodsFor: 'Comandos' stamp: 'BK 10/10/2023 20:06:58'!
avanzar  
	
	location := location + (self class translations at: direction).

	! !

!MarsRover methodsFor: 'Comandos' stamp: 'BK 10/10/2023 20:03:17'!
receive: comandos 

	| switch |
	
	switch := Dictionary new.					
	switch
		at: $f put: [ self avanzar ];
		at: $b put: [ self retroceder ];
		at: $l put: [ self rotarALaIzquierda ];
		at: $r put: [ self rotarALaDerecha ].
	
	comandos do: [ :c | (switch at: c ifAbsent: [^self error: self class invalidCommand]) value. ].
	
	! !

!MarsRover methodsFor: 'Comandos' stamp: 'BK 10/10/2023 20:07:08'!
retroceder  
	
	location := location - (self class translations at: direction).

	! !

!MarsRover methodsFor: 'Comandos' stamp: 'BK 10/10/2023 20:10:27'!
rotarALaDerecha
	
	direction := (self class clockwiseRotations at: direction).

	! !

!MarsRover methodsFor: 'Comandos' stamp: 'BK 10/10/2023 20:08:56'!
rotarALaIzquierda  
	
	direction := (self class counterclockwiseRotations at: direction).

	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRover class' category: 'MarsRover'!
MarsRover class
	instanceVariableNames: ''!

!MarsRover class methodsFor: 'Inicializadores' stamp: 'BK 10/10/2023 18:59:56'!
at: location towards: direction

	(#('N', 'S', 'W', 'E') includes: direction) ifFalse: [ ^self error: self invalidDirection ].

	^ MarsRover new initializeAt: location towards: direction.! !


!MarsRover class methodsFor: 'Errores' stamp: 'BK 10/10/2023 19:39:56'!
invalidCommand

	^ 'invalidCommand'.! !

!MarsRover class methodsFor: 'Errores' stamp: 'BK 10/10/2023 18:52:40'!
invalidDirection

	^ 'invalidDirection'.! !


!MarsRover class methodsFor: 'Diccionarios' stamp: 'BK 10/10/2023 20:13:57'!
clockwiseRotations

	| dicc |
	
	dicc := Dictionary new.					
	dicc
		at: 'N' put: 'E';
		at: 'S' put: 'W';
		at: 'W' put: 'N';
		at: 'E' put: 'S'.
		
	^ dicc! !

!MarsRover class methodsFor: 'Diccionarios' stamp: 'BK 10/10/2023 20:14:02'!
counterclockwiseRotations

	| dicc |
	
	dicc := Dictionary new.					
	dicc
		at: 'N' put: 'W';
		at: 'S' put: 'E';
		at: 'W' put: 'S';
		at: 'E' put: 'N'.
		
	^ dicc! !

!MarsRover class methodsFor: 'Diccionarios' stamp: 'BK 10/10/2023 20:14:10'!
translations

	| dicc |
	
	dicc := Dictionary new.					
	dicc
		at: 'N' put: (0@1);
		at: 'S' put: (0@-1);
		at: 'W' put: (-1@0);
		at: 'E' put: (1@0).
		
	^ dicc! !
