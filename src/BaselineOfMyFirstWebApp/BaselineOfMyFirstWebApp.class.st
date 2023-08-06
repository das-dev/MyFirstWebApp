Class {
	#name : #BaselineOfMyFirstWebApp,
	#superclass : #BaselineOf,
	#category : #BaselineOfMyFirstWebApp
}

{ #category : #baseline }
BaselineOfMyFirstWebApp >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ 
			self
				declareTeapotOn: spec.

			spec
				package: 'MyFirstWebApp';
				package: 'MyFirstWebApp-Tests' with: [ spec requires: #('MyFirstWebApp') ].
 ]
]

{ #category : #'external projects' }
BaselineOfMyFirstWebApp >> declareTeapotOn: spec [
	spec
		baseline: 'Teapot'
		with: [ spec repository: 'github://zeroflag/Teapot/source' ]
]
