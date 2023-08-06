Class {
	#name : #ConfigurationOfMyFirstWebApp,
	#superclass : #Object,
	#instVars : [
		'project'
	],
	#category : #ConfigurationOfMyFirstWebApp
}

{ #category : #'development support' }
ConfigurationOfMyFirstWebApp class >> DevelopmentSupport [

"See the methods in the 'development support' category on the class-side of MetacelloBaseConfiguration. Decide what development support methods you would like to use and copy them the the class-side of your configuration."
	<apiDocumentation>
]

{ #category : #private }
ConfigurationOfMyFirstWebApp class >> baseConfigurationClassIfAbsent: aBlock [

	^self environment 
		at: #'ConfigurationOf'
		ifAbsent: [ 
			self ensureMetacelloBaseConfiguration.
			self environment  at: #'ConfigurationOf' ifAbsent: aBlock ].
]

{ #category : #private }
ConfigurationOfMyFirstWebApp class >> ensureMetacello [

	(self baseConfigurationClassIfAbsent: []) ensureMetacello
]

{ #category : #private }
ConfigurationOfMyFirstWebApp class >> ensureMetacelloBaseConfiguration [
  self environment 
    at: #'ConfigurationOf'
    ifAbsent: [ 
      | repository version |
      repository := MCHttpRepository
        location: 'http://smalltalkhub.com/mc/dkh/metacello/main'
        user: ''
        password: ''.
      repository
        versionReaderForFileNamed: 'Metacello-Base-dkh.107'
        do: [ :reader | 
          version := reader version.
          version load.
          version workingCopy repositoryGroup addRepository: repository ] ]
]

{ #category : #'metacello tool support' }
ConfigurationOfMyFirstWebApp class >> isMetacelloConfig [
	"Answer true and the Metacello tools will operate on you"
	
	^true
]

{ #category : #loading }
ConfigurationOfMyFirstWebApp class >> load [
	"Load the #stable version defined for this platform. The #stable version is the version that is recommended to be used on this platform."

	"self load"

	<apiDocumentation>
	^(self project version: #stable) load
]

{ #category : #loading }
ConfigurationOfMyFirstWebApp class >> loadBleedingEdge [
	"Load the latest versions of the mcz files defined for this project. It is not likely that the #bleedingEdge has been tested."

	"self loadBleedingEdge"

	<apiDocumentation>
	^(self project version: #bleedingEdge) load
]

{ #category : #loading }
ConfigurationOfMyFirstWebApp class >> loadDevelopment [
	"Load the #development version defined for this platform. The #development version will change over time and is not expected to be stable."

	"self loadDevelopment"

	<apiDocumentation>
	^(self project version: #development) load
]

{ #category : #accessing }
ConfigurationOfMyFirstWebApp class >> project [

	^self new project
]

{ #category : #'development support' }
ConfigurationOfMyFirstWebApp class >> validate [
	"Check the configuration for Errors, Critical Warnings, and Warnings (see class comment for MetacelloMCVersionValidator for more information). 
	Errors identify specification issues that will result in unexpected behaviour when you load the configuration. 
	Critical Warnings identify specification issues that may result in unexpected behavior when you load the configuration.
	Warnings identify specification issues that are technically correct, but are worth take a look at."

	"self validate"

	<apiDocumentation>
	self ensureMetacello.
	^ ((self environment  at: #MetacelloToolBox) validateConfiguration: self debug: #() recurse: false) inspect
]

{ #category : #baselines }
ConfigurationOfMyFirstWebApp >> baseline1: spec [

	<version: '1-baseline'>
	spec for: #common do: [
		spec
			blessing: #baseline;
			repository:
				'github://das-dev/MyFirstWebApp';
			package: 'MyFirstWebApp' ]
]

{ #category : #accessing }
ConfigurationOfMyFirstWebApp >> customProjectAttributes [
    "Edit to return a collection of any custom attributes e.g. for conditional loading: Array with: #'Condition1' with: #'Condition2.
	For more information see: http://code.google.com/p/metacello/wiki/CustomProjectAttrributes "

    ^ #()
]

{ #category : #accessing }
ConfigurationOfMyFirstWebApp >> project [
    ^ project
        ifNil: [ 
            "Bootstrap Metacello if it is not already loaded"
            self class ensureMetacello.
            project := MetacelloMCProject new projectAttributes: self customProjectAttributes.	"Create the Metacello project"
            (Smalltalk at: #'MetacelloVersionConstructor') on: self project: project.	"Construct the project"
            project loadType: #'linear'.	"change to #atomic if desired"
            project ]
]

{ #category : #'symbolic versions' }
ConfigurationOfMyFirstWebApp >> stable: spec [

	<symbolicVersion: #stable>
	spec for: #common version: '1'
]

{ #category : #versions }
ConfigurationOfMyFirstWebApp >> version1: spec [

	<version: '1' imports: #( '1-baseline' )>
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'MyFirstWebApp' ]
]
