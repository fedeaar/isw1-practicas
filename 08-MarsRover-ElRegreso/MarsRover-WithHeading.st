!classDefinition: #MarsRoverLogTests category: 'MarsRover-WithHeading'!
TestCase subclass: #MarsRoverLogTests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverLogTests methodsFor: 'helpers' stamp: 'fa 10/30/2023 19:43:47'!
execute: aBlock forLog: aLog withMarsRoverAt: aPosition andDirection: aDirection
	
	| marsRover initialPosition initialDirection |
	
	initialPosition := MarsRoverPositionProxy at: aPosition.
	initialDirection := MarsRoverHeadingProxy for: aDirection.
	marsRover  := MarsRover 
		at: initialPosition
		heading: initialDirection.	
	
	aLog 
		registerFor: initialPosition ;
		registerFor: initialDirection.
		
	aBlock value: marsRover value: aLog.
! !


!MarsRoverLogTests methodsFor: 'headings' stamp: 'fa 10/30/2023 20:04:12'!
east

	^ MarsRoverHeadingEast ! !

!MarsRoverLogTests methodsFor: 'headings' stamp: 'fa 10/30/2023 20:04:31'!
north

	^ MarsRoverHeadingNorth! !

!MarsRoverLogTests methodsFor: 'headings' stamp: 'fa 10/30/2023 20:04:36'!
south

	^ MarsRoverHeadingSouth! !

!MarsRoverLogTests methodsFor: 'headings' stamp: 'fa 10/30/2023 20:04:26'!
west

	^ MarsRoverHeadingWest ! !


!MarsRoverLogTests methodsFor: 'assertions' stamp: 'fa 10/30/2023 19:44:05'!
assertLog: aLog displays: aView afterProcessing: aSequenceOfCommands forMarsRoverAt: aPosition andDirection: aDirection
	
	self execute: [ :marsRover :log | 
		marsRover process: aSequenceOfCommands.
		self assert: (log createView) = aView.	
	] forLog: aLog withMarsRoverAt: aPosition andDirection: aDirection.
! !

!MarsRoverLogTests methodsFor: 'assertions' stamp: 'fa 10/30/2023 19:43:38'!
assertLog: aLog sequentiallyDisplays: aViewList afterProcessing: aSequenceOfCommandsList forMarsRoverAt: aPosition andDirection: aDirection
	
	self assert: aViewList size = aSequenceOfCommandsList size.	
	
	self execute: [ :marsRover :log | 
		(1 to: (aViewList size)) do: [ :index |
			marsRover process: (aSequenceOfCommandsList at: index).	
			self assert: (log createView) = (aViewList at: index).
		].
	] forLog: aLog withMarsRoverAt: aPosition andDirection: aDirection.
! !


!classDefinition: #MarsRoverBasicLogTest category: 'MarsRover-WithHeading'!
MarsRoverLogTests subclass: #MarsRoverBasicLogTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverBasicLogTest methodsFor: 'tests' stamp: 'fa 10/30/2023 18:47:49'!
test01seLogeaElPrimerMovimiento

	self
		assertLog: MarsRoverBasicLog new 
		displays: (OrderedCollection with: (1@2)) 
		afterProcessing: 'f' 
		forMarsRoverAt:  (1@1)
		andDirection: self north. 
! !

!MarsRoverBasicLogTest methodsFor: 'tests' stamp: 'fa 10/30/2023 18:47:47'!
test02seLogeaElSegundoMovimiento

	self
		assertLog: MarsRoverBasicLog new 
		displays: (OrderedCollection with: (1@2) with: (1 @ 3)) 
		afterProcessing: 'ff' 
		forMarsRoverAt:  (1@1)
		andDirection: self north. 
! !

!MarsRoverBasicLogTest methodsFor: 'tests' stamp: 'fa 10/30/2023 18:47:44'!
test03seLogeaUnCambioDeDireccion

	self
		assertLog: MarsRoverBasicLog new 
		displays: (OrderedCollection with: 'East') 
		afterProcessing: 'r' 
		forMarsRoverAt:  (1@1)
		andDirection: self north. 
! !

!MarsRoverBasicLogTest methodsFor: 'tests' stamp: 'fa 10/30/2023 18:47:41'!
test04seLogeaElSegundoCambioDeDireccion

	self
		assertLog: MarsRoverBasicLog new 
		displays: (OrderedCollection with: 'East' with: 'North') 
		afterProcessing: 'rl' 
		forMarsRoverAt:  (1@1)
		andDirection: self north. 
! !

!MarsRoverBasicLogTest methodsFor: 'tests' stamp: 'fa 10/30/2023 18:47:38'!
test05seLogeanLaPosicionYLaDireccionEnSimultaneo
	
	self
		assertLog: MarsRoverBasicLog new 
		displays: (OrderedCollection with: (1@2) with: 'East') 
		afterProcessing: 'fr' 
		forMarsRoverAt:  (1@1)
		andDirection: self north. 
! !


!classDefinition: #MarsRoverWindowLogTest category: 'MarsRover-WithHeading'!
MarsRoverLogTests subclass: #MarsRoverWindowLogTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverWindowLogTest methodsFor: 'tests' stamp: 'fa 10/30/2023 20:00:17'!
test01seMuestraElPrimerMovimiento

	self
		assertLog: MarsRoverWindowLog new 
		displays: (Dictionary with: 'posición'->(1@2) with: 'dirección'->'') 
		afterProcessing: 'f' 
		forMarsRoverAt:  (1@1)
		andDirection: self north. 
! !

!MarsRoverWindowLogTest methodsFor: 'tests' stamp: 'fa 10/30/2023 20:00:55'!
test02seMuestranEnSecuenciaDosMovimientos
	
	self
		assertLog: MarsRoverWindowLog new 
		sequentiallyDisplays: (OrderedCollection 
			with: (Dictionary with: 'posición'->(1@2) with: 'dirección'->'')
			with: (Dictionary with: 'posición'->(1@3) with: 'dirección'->''))
		afterProcessing: (OrderedCollection
			with: 'f'
			with: 'f') 
		forMarsRoverAt:  (1@1)
		andDirection: self north.
! !

!MarsRoverWindowLogTest methodsFor: 'tests' stamp: 'fa 10/30/2023 20:00:25'!
test03seMuestraUnCambioDeRotacion

	self
		assertLog: MarsRoverWindowLog new 
		displays: (Dictionary with: 'posición'->'' with: 'dirección'->'Apuntando al Este') 
		afterProcessing: 'r' 
		forMarsRoverAt:  (1@1)
		andDirection: self north. 
! !

!MarsRoverWindowLogTest methodsFor: 'tests' stamp: 'fa 10/30/2023 20:00:28'!
test04seMuestranElPrimeroMovimientoYRotacion

	self
		assertLog: MarsRoverWindowLog new 
		displays: (Dictionary with: 'posición'->(1@2) with: 'dirección'->'Apuntando al Este') 
		afterProcessing: 'fr' 
		forMarsRoverAt:  (1@1)
		andDirection: self north. 
! !

!MarsRoverWindowLogTest methodsFor: 'tests' stamp: 'fa 10/30/2023 20:00:33'!
test05seMuestranTodosLosCambiosEnSecuencia

	self
		assertLog: MarsRoverWindowLog new 
		sequentiallyDisplays: (OrderedCollection 
			with: (Dictionary with: 'posición'->(1@2) with: 'dirección'->'')
			with: (Dictionary with: 'posición'->(1@2) with: 'dirección'->'Apuntando al Este')
			with: (Dictionary with: 'posición'->(2@2) with: 'dirección'->'Apuntando al Este')
			with: (Dictionary with: 'posición'->(2@2) with: 'dirección'->'Apuntando al Oeste'))
		afterProcessing: (OrderedCollection
			with: 'f'
			with: 'r'
			with: 'f'
			with: 'll') 
		forMarsRoverAt:  (1@1)
		andDirection: self north.
! !


!classDefinition: #MarsRoverTest category: 'MarsRover-WithHeading'!
TestCase subclass: #MarsRoverTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:21:23'!
test01DoesNotMoveWhenNoCommand

	self 
		assertIsAt: 1@2 
		heading: self north 
		afterProcessing: '' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:28:12'!
test02IsAtFailsForDifferentPosition

	| marsRover |
	
	marsRover := MarsRover at: 1@1 heading: self north . 
	
	self deny: (marsRover isAt: 1@2 heading: self north)! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:28:31'!
test03IsAtFailsForDifferentHeading

	| marsRover |
	
	marsRover := MarsRover at: 1@1 heading: self north . 
	
	self deny: (marsRover isAt: 1@1 heading: self south)! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:30:17'!
test04IncrementsYAfterMovingForwardWhenHeadingNorth

	self 
		assertIsAt: 1@3 
		heading: self north 
		afterProcessing: 'f' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:30:11'!
test06DecrementsYAfterMovingBackwardsWhenHeadingNorth

	self 
		assertIsAt: 1@1 
		heading: self north 
		afterProcessing: 'b' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:59'!
test07PointToEashAfterRotatingRightWhenHeadingNorth

	self 
		assertIsAt: 1@2 
		heading: self east 
		afterProcessing: 'r' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:51'!
test08PointsToWestAfterRotatingLeftWhenPointingNorth

	self 
		assertIsAt: 1@2 
		heading: self west 
		afterProcessing: 'l' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:45'!
test09DoesNotProcessInvalidCommand

	| marsRover |
	
	marsRover := MarsRover at: 1@2 heading: self north.
	
	self 
		should: [ marsRover process: 'x' ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: marsRover invalidCommandErrorDescription.
			self assert: (marsRover isAt: 1@2 heading: self north) ]! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:39'!
test10CanProcessMoreThanOneCommand

	self 
		assertIsAt: 1@4 
		heading: self north 
		afterProcessing: 'ff' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:31'!
test11IncrementsXAfterMovingForwareWhenHeadingEast

	self 
		assertIsAt: 2@2 
		heading: self east 
		afterProcessing: 'f' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:19'!
test12DecrementsXAfterMovingBackwardWhenHeadingEast

	self 
		assertIsAt: 0@2 
		heading: self east 
		afterProcessing: 'b' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:14'!
test13PointsToSouthAfterRotatingRightWhenHeadingEast

		self 
		assertIsAt: 1@2 
		heading: self south 
		afterProcessing: 'r' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:05'!
test14PointsToNorthAfterRotatingLeftWhenPointingEast

		self 
		assertIsAt: 1@2 
		heading: self north 
		afterProcessing: 'l' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:00'!
test15ForwardBackwardsAndRotateRightWorkAsExpectedWhenPointingSouth

	self 
		assertIsAt: 1@1 
		heading: self west 
		afterProcessing: 'ffblrr' 
		whenStartingAt: 1@2 
		heading: self south 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:28:52'!
test16ForwardBackwardsAndRotateRightWorkAsExpectedWhenPointingWest

	self 
		assertIsAt: 0@2 
		heading: self north 
		afterProcessing: 'ffblrr' 
		whenStartingAt: 1@2 
		heading: self west 
! !


!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:31'!
east

	^ MarsRoverHeadingEast ! !

!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:38'!
north

	^ MarsRoverHeadingNorth ! !

!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:45'!
south

	^ MarsRoverHeadingSouth ! !

!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:54'!
west

	^ MarsRoverHeadingWest ! !


!MarsRoverTest methodsFor: 'assertions' stamp: 'fa 10/30/2023 16:52:16'!
assertIsAt: newPosition heading: newHeadingType afterProcessing: commands whenStartingAt: startPosition heading: startHeadingType

	| marsRover |
	
	marsRover := MarsRover at: startPosition heading: startHeadingType. 
	
	marsRover process: commands.
	
	self assert: (marsRover isAt: newPosition heading: newHeadingType)! !


!classDefinition: #MarsRover category: 'MarsRover-WithHeading'!
Object subclass: #MarsRover
	instanceVariableNames: 'position head'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRover methodsFor: 'exceptions' stamp: 'HAW 6/30/2018 19:48:45'!
invalidCommandErrorDescription
	
	^'Invalid command'! !

!MarsRover methodsFor: 'exceptions' stamp: 'HAW 6/30/2018 19:50:26'!
signalInvalidCommand
	
	self error: self invalidCommandErrorDescription ! !


!MarsRover methodsFor: 'initialization' stamp: 'BK 10/29/2023 19:36:49'!
initializeAt: aPosition heading: aHeadingType

	position := aPosition.
	head := aHeadingType for: self.! !


!MarsRover methodsFor: 'heading' stamp: 'BK 10/29/2023 19:23:08'!
headEast
	
	head := head headEastFor: self.! !

!MarsRover methodsFor: 'heading' stamp: 'BK 10/29/2023 19:25:00'!
headNorth
	
	head := head headNorthFor: self.! !

!MarsRover methodsFor: 'heading' stamp: 'BK 10/29/2023 19:25:08'!
headSouth
	
	head := head headSouthFor: self.! !

!MarsRover methodsFor: 'heading' stamp: 'BK 10/29/2023 19:25:18'!
headWest
	
	head := head headWestFor: self.! !

!MarsRover methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	head rotateLeft! !

!MarsRover methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	head rotateRight! !


!MarsRover methodsFor: 'testing' stamp: 'HAW 10/7/2021 20:16:32'!
isAt: aPosition heading: aHeadingType

	^position = aPosition and: [ head isHeading: aHeadingType ]! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:16:51'!
isBackwardCommand: aCommand

	^aCommand = $b! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:16:19'!
isForwardCommand: aCommand

	^aCommand = $f ! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:17:51'!
isRotateLeftCommand: aCommand

	^aCommand = $l! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:17:21'!
isRotateRightCommand: aCommand

	^aCommand = $r! !


!MarsRover methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward
	
	head moveBackward! !

!MarsRover methodsFor: 'moving' stamp: 'HAW 8/22/2019 12:15:01'!
moveEast
	
	position := position + (1@0)! !

!MarsRover methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	head moveForward! !

!MarsRover methodsFor: 'moving' stamp: 'HAW 8/22/2019 12:13:12'!
moveNorth
	
	position := position + (0@1)! !

!MarsRover methodsFor: 'moving' stamp: 'HAW 8/22/2019 12:13:34'!
moveSouth
	
	position := position + (0@-1)! !

!MarsRover methodsFor: 'moving' stamp: 'HAW 8/22/2019 12:15:32'!
moveWest
	
	position := position + (-1@0)! !


!MarsRover methodsFor: 'command processing' stamp: 'HAW 6/30/2018 19:48:26'!
process: aSequenceOfCommands

	aSequenceOfCommands do: [:aCommand | self processCommand: aCommand ]
! !

!MarsRover methodsFor: 'command processing' stamp: 'HAW 8/22/2019 12:08:50'!
processCommand: aCommand

	(self isForwardCommand: aCommand) ifTrue: [ ^ self moveForward ].
	(self isBackwardCommand: aCommand) ifTrue: [ ^ self moveBackward ].
	(self isRotateRightCommand: aCommand) ifTrue: [ ^ self rotateRight ].
	(self isRotateLeftCommand: aCommand) ifTrue: [ ^ self rotateLeft ].

	self signalInvalidCommand.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRover class' category: 'MarsRover-WithHeading'!
MarsRover class
	instanceVariableNames: 'headings'!

!MarsRover class methodsFor: 'instance creation' stamp: 'HAW 10/7/2021 20:10:30'!
at: aPosition heading: aHeadingType
	
	^self new initializeAt: aPosition heading: aHeadingType! !


!classDefinition: #MarsRoverCollaborators category: 'MarsRover-WithHeading'!
Object subclass: #MarsRoverCollaborators
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverCollaborators methodsFor: 'display' stamp: 'fa 10/30/2023 17:26:28'!
displayFor: aDisplay

	self subclassResponsibility.! !

!MarsRoverCollaborators methodsFor: 'display' stamp: 'fa 10/30/2023 20:06:35'!
displayTypeFor: aDisplay

	self subclassResponsibility.! !


!classDefinition: #MarsRoverHeading category: 'MarsRover-WithHeading'!
MarsRoverCollaborators subclass: #MarsRoverHeading
	instanceVariableNames: 'marsRover'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeading methodsFor: 'heading' stamp: 'fa 10/30/2023 16:50:50'!
headEastFor: aMarsRover

	^MarsRoverHeadingEast for: aMarsRover.! !

!MarsRoverHeading methodsFor: 'heading' stamp: 'fa 10/30/2023 16:51:08'!
headNorthFor: aMarsRover

	^MarsRoverHeadingNorth for: aMarsRover.! !

!MarsRoverHeading methodsFor: 'heading' stamp: 'fa 10/30/2023 16:51:42'!
headSouthFor: aMarsRover

	^MarsRoverHeadingSouth for: aMarsRover.! !

!MarsRoverHeading methodsFor: 'heading' stamp: 'fa 10/30/2023 16:51:22'!
headWestFor: aMarsRover

	^MarsRoverHeadingWest for: aMarsRover.! !

!MarsRoverHeading methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft

	self subclassResponsibility ! !

!MarsRoverHeading methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight

	self subclassResponsibility ! !


!MarsRoverHeading methodsFor: 'testing' stamp: 'HAW 10/7/2021 20:15:38'!
isHeading: aHeadingType

	^self isKindOf: aHeadingType ! !


!MarsRoverHeading methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward

	self subclassResponsibility ! !

!MarsRoverHeading methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward

	self subclassResponsibility ! !


!MarsRoverHeading methodsFor: 'display' stamp: 'fa 10/30/2023 17:12:13'!
displayFor: aDisplay

	self subclassResponsibility.! !

!MarsRoverHeading methodsFor: 'display' stamp: 'fa 10/30/2023 19:16:45'!
displayTypeFor: aDisplay

	^aDisplay displayHeadingType: self.! !


!MarsRoverHeading methodsFor: 'initialization' stamp: 'HAW 10/7/2021 20:11:59'!
initializeFor: aMarsRover 
	
	marsRover := aMarsRover.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverHeading class' category: 'MarsRover-WithHeading'!
MarsRoverHeading class
	instanceVariableNames: ''!

!MarsRoverHeading class methodsFor: 'instance creation' stamp: 'HAW 10/7/2021 20:11:35'!
for: aMarsRover 
	
	^self new initializeFor: aMarsRover ! !


!classDefinition: #MarsRoverHeadingEast category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingEast
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingEast methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward
	
	^marsRover moveWest! !

!MarsRoverHeadingEast methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveEast! !


!MarsRoverHeadingEast methodsFor: 'display' stamp: 'fa 10/30/2023 18:36:46'!
displayFor: aDisplay

	^aDisplay displayHeadingEast: self.! !


!MarsRoverHeadingEast methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headNorth! !

!MarsRoverHeadingEast methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headSouth! !


!classDefinition: #MarsRoverHeadingNorth category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingNorth
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingNorth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward
	
	^marsRover moveSouth! !

!MarsRoverHeadingNorth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveNorth! !


!MarsRoverHeadingNorth methodsFor: 'display' stamp: 'fa 10/30/2023 18:37:03'!
displayFor: aDisplay

	^aDisplay displayHeadingNorth: self.! !


!MarsRoverHeadingNorth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headWest! !

!MarsRoverHeadingNorth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headEast! !


!classDefinition: #MarsRoverHeadingSouth category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingSouth
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingSouth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward
	
	^marsRover moveNorth! !

!MarsRoverHeadingSouth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveSouth! !


!MarsRoverHeadingSouth methodsFor: 'display' stamp: 'fa 10/30/2023 18:37:08'!
displayFor: aDisplay

	^aDisplay displayHeadingSouth: self.! !


!MarsRoverHeadingSouth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headEast! !

!MarsRoverHeadingSouth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headWest! !


!classDefinition: #MarsRoverHeadingWest category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingWest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingWest methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward

	^marsRover moveEast! !

!MarsRoverHeadingWest methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveWest! !


!MarsRoverHeadingWest methodsFor: 'display' stamp: 'fa 10/30/2023 18:37:13'!
displayFor: aDisplay

	^aDisplay displayHeadingWest: self.! !


!MarsRoverHeadingWest methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headSouth! !

!MarsRoverHeadingWest methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headNorth! !


!classDefinition: #MarsRoverNullCollaborator category: 'MarsRover-WithHeading'!
MarsRoverCollaborators subclass: #MarsRoverNullCollaborator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverNullCollaborator methodsFor: 'display' stamp: 'fa 10/30/2023 19:17:04'!
displayFor: aDisplay

	^aDisplay displayNullCollaborator: self.! !

!MarsRoverNullCollaborator methodsFor: 'display' stamp: 'fa 10/30/2023 19:17:00'!
displayTypeFor: aDisplay

	^aDisplay displayNullCollaboratorType: self.! !


!classDefinition: #MarsRoverPosition category: 'MarsRover-WithHeading'!
MarsRoverCollaborators subclass: #MarsRoverPosition
	instanceVariableNames: 'position'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverPosition methodsFor: 'translation' stamp: 'fa 10/30/2023 18:32:29'!
+ aTranslation

	position := aTranslation + position.
	^ self.! !


!MarsRoverPosition methodsFor: 'display' stamp: 'fa 10/30/2023 18:03:17'!
displayFor: aDisplay

	^aDisplay displayPosition: self.! !

!MarsRoverPosition methodsFor: 'display' stamp: 'fa 10/30/2023 19:15:55'!
displayTypeFor: aDisplay

	^aDisplay displayPositionType: self.! !


!MarsRoverPosition methodsFor: 'accessing' stamp: 'fa 10/30/2023 17:31:06'!
position

	^ position.! !


!MarsRoverPosition methodsFor: 'testing' stamp: 'fa 10/30/2023 17:37:34'!
= aPositionOrMarsRoverPosition

	^ aPositionOrMarsRoverPosition = position.! !


!MarsRoverPosition methodsFor: 'initialization' stamp: 'fa 10/30/2023 17:24:07'!
initializeAt: aPosition

	position := aPosition.
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverPosition class' category: 'MarsRover-WithHeading'!
MarsRoverPosition class
	instanceVariableNames: ''!

!MarsRoverPosition class methodsFor: 'instance creation' stamp: 'fa 10/30/2023 17:34:49'!
at: aPosition

	^ self new initializeAt: aPosition.! !


!classDefinition: #MarsRoverLog category: 'MarsRover-WithHeading'!
Object subclass: #MarsRoverLog
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverLog methodsFor: 'display' stamp: 'fa 10/30/2023 19:04:03'!
createView

	self subclassResponsibility.! !

!MarsRoverLog methodsFor: 'display' stamp: 'fa 10/30/2023 19:02:14'!
displayHeadingEast: aMarsRoverHeadingEastCollaborator

	self subclassResponsibility.! !

!MarsRoverLog methodsFor: 'display' stamp: 'fa 10/30/2023 19:02:40'!
displayHeadingNorth: aMarsRoverHeadingNorthCollaborator

	self subclassResponsibility.! !

!MarsRoverLog methodsFor: 'display' stamp: 'fa 10/30/2023 19:02:31'!
displayHeadingSouth: aMarsRoverHeadingSouthCollaborator

	self subclassResponsibility.! !

!MarsRoverLog methodsFor: 'display' stamp: 'fa 10/30/2023 19:17:43'!
displayHeadingType: aMarsRoverHeadingCollaborator

	self subclassResponsibility.! !

!MarsRoverLog methodsFor: 'display' stamp: 'fa 10/30/2023 19:02:22'!
displayHeadingWest: aMarsRoverHeadingWestCollaborator

	self subclassResponsibility.! !

!MarsRoverLog methodsFor: 'display' stamp: 'fa 10/30/2023 19:18:03'!
displayNullCollaborator: aMarsRoverNullCollaborator

	self subclassResponsibility.! !

!MarsRoverLog methodsFor: 'display' stamp: 'fa 10/30/2023 19:18:06'!
displayNullCollaboratorType: aMarsRoverNullCollaborator

	self subclassResponsibility.! !

!MarsRoverLog methodsFor: 'display' stamp: 'fa 10/30/2023 19:02:50'!
displayPosition: aMarsRoverPositionCollaborator

	self subclassResponsibility.! !

!MarsRoverLog methodsFor: 'display' stamp: 'fa 10/30/2023 19:17:24'!
displayPositionType: aMarsRoverPositionCollaborator

	self subclassResponsibility.! !


!MarsRoverLog methodsFor: 'register' stamp: 'fa 10/30/2023 19:01:32'!
registerFor: aProxy

	self subclassResponsibility.! !


!classDefinition: #MarsRoverBasicLog category: 'MarsRover-WithHeading'!
MarsRoverLog subclass: #MarsRoverBasicLog
	instanceVariableNames: 'log'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverBasicLog methodsFor: 'register' stamp: 'fa 10/30/2023 18:33:06'!
registerFor: aProxy

	aProxy register: [:newValue |	
		log add: newValue copy.
	].! !


!MarsRoverBasicLog methodsFor: 'initialization' stamp: 'fa 10/30/2023 16:58:14'!
initialize

	log := OrderedCollection new.! !


!MarsRoverBasicLog methodsFor: 'display' stamp: 'fa 10/30/2023 17:57:22'!
createView
	
	| output |
	output := OrderedCollection new.
	
	log do: [ :aLogEntry | 
		output add: (aLogEntry displayFor: self).
	].

	^ output.! !

!MarsRoverBasicLog methodsFor: 'display' stamp: 'fa 10/30/2023 19:01:11'!
displayHeadingEast: aMarsRoverHeadingEastCollaborator

	^ 'East'.! !

!MarsRoverBasicLog methodsFor: 'display' stamp: 'fa 10/30/2023 19:01:08'!
displayHeadingNorth: aMarsRoverHeadingNorthCollaborator

	^ 'North'.! !

!MarsRoverBasicLog methodsFor: 'display' stamp: 'fa 10/30/2023 19:01:06'!
displayHeadingSouth: aMarsRoverHeadingSouthCollaborator

	^ 'South'.! !

!MarsRoverBasicLog methodsFor: 'display' stamp: 'fa 10/30/2023 19:01:00'!
displayHeadingWest: aMarsRoverHeadingWestCollaborator

	^ 'West'.! !

!MarsRoverBasicLog methodsFor: 'display' stamp: 'fa 10/30/2023 18:00:32'!
displayInTranscript

	^ (self createView) do: [ :aLogEntryView | 
		Transcript show: aLogEntryView ; newLine. 
	].! !

!MarsRoverBasicLog methodsFor: 'display' stamp: 'fa 10/30/2023 19:00:52'!
displayNullCollaborator: aMarsRoverNullCollaborator

	"do nothing"! !

!MarsRoverBasicLog methodsFor: 'display' stamp: 'fa 10/30/2023 19:03:04'!
displayPosition: aMarsRoverPositionCollaborator

	^ aMarsRoverPositionCollaborator position.! !


!classDefinition: #MarsRoverWindowLog category: 'MarsRover-WithHeading'!
MarsRoverLog subclass: #MarsRoverWindowLog
	instanceVariableNames: 'log'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverWindowLog methodsFor: 'initialization' stamp: 'fa 10/30/2023 19:04:55'!
initialize

	log := Dictionary new.! !


!MarsRoverWindowLog methodsFor: 'register' stamp: 'fa 10/30/2023 19:36:15'!
registerFor: aProxy

	log add: (aProxy displayTypeFor: self) -> MarsRoverNullCollaborator new. 
	aProxy register: [:newValue |	
		log at: (aProxy displayTypeFor: self) put: newValue.
	].! !


!MarsRoverWindowLog methodsFor: 'display' stamp: 'fa 10/30/2023 19:21:00'!
createView
	
	| output |
	output := Dictionary new.
	
	log keysAndValuesDo: [ :aLogCollaboratorType :aLogCollaboratorValue | 
		output add:  aLogCollaboratorType->(aLogCollaboratorValue displayFor: self).
	].

	^ output.! !

!MarsRoverWindowLog methodsFor: 'display' stamp: 'fa 10/30/2023 19:09:47'!
displayHeadingEast: aMarsRoverHeadingEastCollaborator

	^ 'Apuntando al Este'.! !

!MarsRoverWindowLog methodsFor: 'display' stamp: 'fa 10/30/2023 19:09:53'!
displayHeadingNorth: aMarsRoverHeadingNorthCollaborator

	^ 'Apuntando al Norte'.! !

!MarsRoverWindowLog methodsFor: 'display' stamp: 'fa 10/30/2023 19:09:58'!
displayHeadingSouth: aMarsRoverHeadingSouthCollaborator

	^ 'Apuntando al Sur'.! !

!MarsRoverWindowLog methodsFor: 'display' stamp: 'fa 10/30/2023 19:21:14'!
displayHeadingType: aMarsRoverHeadingCollaborator

	^ 'dirección'.! !

!MarsRoverWindowLog methodsFor: 'display' stamp: 'fa 10/30/2023 19:10:04'!
displayHeadingWest: aMarsRoverHeadingWestCollaborator

	^ 'Apuntando al Oeste'.! !

!MarsRoverWindowLog methodsFor: 'display' stamp: 'fa 10/30/2023 19:23:16'!
displayInTranscript

	^ (self createView) keysAndValuesDo: [ :aLogEntryType :aLogEntryView | 
		Transcript show: aLogEntryType, ': ', aLogEntryView ; newLine. 
	].! !

!MarsRoverWindowLog methodsFor: 'display' stamp: 'fa 10/30/2023 19:10:13'!
displayNullCollaborator: aMarsRoverNullCollaborator

	^ ''.! !

!MarsRoverWindowLog methodsFor: 'display' stamp: 'fa 10/30/2023 19:06:23'!
displayPosition: aMarsRoverPositionCollaborator

	^ aMarsRoverPositionCollaborator position.! !

!MarsRoverWindowLog methodsFor: 'display' stamp: 'fa 10/30/2023 19:19:28'!
displayPositionType: aMarsRoverPositionCollaborator

	^ 'posición'.! !


!classDefinition: #MarsRoverProxies category: 'MarsRover-WithHeading'!
Object subclass: #MarsRoverProxies
	instanceVariableNames: 'listeners'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverProxies methodsFor: 'initialization' stamp: 'BK 10/29/2023 21:01:27'!
initialize

	listeners := OrderedCollection new.! !


!MarsRoverProxies methodsFor: 'display' stamp: 'fa 10/30/2023 18:51:52'!
displayFor: aDisplay

	self subclassResponsibility.! !

!MarsRoverProxies methodsFor: 'display' stamp: 'fa 10/30/2023 20:02:57'!
displayTypeFor: aDisplay

	self subclassResponsibility.! !


!MarsRoverProxies methodsFor: 'logging' stamp: 'BK 10/29/2023 21:05:21'!
log: aValue

	listeners do: [ :listener | listener value: aValue ].! !

!MarsRoverProxies methodsFor: 'logging' stamp: 'BK 10/29/2023 21:00:40'!
register: aListener

	listeners add: aListener.! !


!classDefinition: #MarsRoverHeadingProxy category: 'MarsRover-WithHeading'!
MarsRoverProxies subclass: #MarsRoverHeadingProxy
	instanceVariableNames: 'head'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingProxy methodsFor: 'moving' stamp: 'BK 10/29/2023 19:53:12'!
moveBackward.

	^ head moveBackward.! !

!MarsRoverHeadingProxy methodsFor: 'moving' stamp: 'BK 10/29/2023 19:53:07'!
moveForward

	^ head moveForward.! !


!MarsRoverHeadingProxy methodsFor: 'heading' stamp: 'fa 10/30/2023 19:53:23'!
headEastFor: aMarsRover

	head := MarsRoverHeadingEast for: aMarsRover.
	self log: head.
	^self.! !

!MarsRoverHeadingProxy methodsFor: 'heading' stamp: 'fa 10/30/2023 19:53:28'!
headNorthFor: aMarsRover

	head := MarsRoverHeadingNorth for: aMarsRover.
	self log: head.
	^self.! !

!MarsRoverHeadingProxy methodsFor: 'heading' stamp: 'fa 10/30/2023 19:53:33'!
headSouthFor: aMarsRover

	head := MarsRoverHeadingSouth for: aMarsRover.
	self log: head.
	^self.! !

!MarsRoverHeadingProxy methodsFor: 'heading' stamp: 'fa 10/30/2023 19:53:37'!
headWestFor: aMarsRover

	head := MarsRoverHeadingWest for: aMarsRover.
	self log: head.
	^self.! !

!MarsRoverHeadingProxy methodsFor: 'heading' stamp: 'BK 10/29/2023 19:54:59'!
rotateLeft

	^ head rotateLeft.! !

!MarsRoverHeadingProxy methodsFor: 'heading' stamp: 'BK 10/29/2023 19:54:54'!
rotateRight

	^ head rotateRight.! !


!MarsRoverHeadingProxy methodsFor: 'testing' stamp: 'BK 10/29/2023 19:48:57'!
isHeading: aHeadingType

	^ head isHeading: aHeadingType.! !


!MarsRoverHeadingProxy methodsFor: 'display' stamp: 'fa 10/30/2023 17:19:41'!
displayFor: aDisplay

	^head displayFor: aDisplay.! !

!MarsRoverHeadingProxy methodsFor: 'display' stamp: 'fa 10/30/2023 19:14:46'!
displayTypeFor: aDisplay
	
	^ head displayTypeFor: aDisplay.! !


!MarsRoverHeadingProxy methodsFor: 'initialization' stamp: 'fa 10/30/2023 18:19:50'!
for: aMarsRover

	head := head for: aMarsRover.! !

!MarsRoverHeadingProxy methodsFor: 'initialization' stamp: 'fa 10/30/2023 18:20:13'!
initializeWith: aHeadingClass

	head := aHeadingClass.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverHeadingProxy class' category: 'MarsRover-WithHeading'!
MarsRoverHeadingProxy class
	instanceVariableNames: ''!

!MarsRoverHeadingProxy class methodsFor: 'instance creation' stamp: 'fa 10/30/2023 18:16:56'!
for: aHeading

	^ self new initializeWith: aHeading.! !


!classDefinition: #MarsRoverPositionProxy category: 'MarsRover-WithHeading'!
MarsRoverProxies subclass: #MarsRoverPositionProxy
	instanceVariableNames: 'position'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverPositionProxy methodsFor: 'accessing' stamp: 'fa 10/30/2023 17:30:35'!
position

	^ position.! !


!MarsRoverPositionProxy methodsFor: 'initialization' stamp: 'fa 10/30/2023 17:34:34'!
initializeAt: aPosition

	position := MarsRoverPosition at: aPosition.! !


!MarsRoverPositionProxy methodsFor: 'display' stamp: 'fa 10/30/2023 17:31:55'!
displayFor: aDisplay

	^position displayFor: aDisplay.! !

!MarsRoverPositionProxy methodsFor: 'display' stamp: 'fa 10/30/2023 19:25:46'!
displayTypeFor: aDisplay
	
	^position displayTypeFor: aDisplay.! !


!MarsRoverPositionProxy methodsFor: 'testing' stamp: 'fa 10/30/2023 17:38:52'!
= aPositionOrMarsRoverPosition

	^ position = aPositionOrMarsRoverPosition.! !


!MarsRoverPositionProxy methodsFor: 'translation' stamp: 'fa 10/30/2023 18:32:52'!
+ aTranslation

	position := position + aTranslation.
	self log: position.
	
	^ self.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverPositionProxy class' category: 'MarsRover-WithHeading'!
MarsRoverPositionProxy class
	instanceVariableNames: ''!

!MarsRoverPositionProxy class methodsFor: 'instance creation' stamp: 'fa 10/30/2023 17:30:07'!
at: aPosition

	^ self new initializeAt: aPosition.! !
