# RealPage Calculator Project (RPC)
## A Ruby Command-Line Reverse Polish Notation (RPN) Calculator
[Original Specifications][specs]

## In This Document

+ [Solution Overview](#solution-overview)
+ [Technical/Architectural Reasoning](#technicalarchitectural-reasoning)
+ [Technical/Architectural Reflections](#technicalarchitectural-reflections)
+ [Creating a New Interface](#creating-a-new-interface)

## Solution Overview
The RPC project consists of: 
+ Two _primary class categories_.
+ Several _secondary class categories_ whose sole purpose is to facilitate the functionality of the _primary classes_.
+ A series of _support classes/modules_ that assist with the overall funcionality of this project.
+ _Configuration files_ used to dynamically configure this project.
+ An _executable command-line scripts_ that allows Users to run and interact with a particular _Calculator_ in a UNIX-like CLI.

### Primary Class Categories

| Primary Class Category        | Example Class | High-Level Function |
|-------------:|:-------------|:------------------|
| IO Interfaces | `RealPage::Calculator::IOInterface` `RealPage::Calculator::ConsoleInterface`  | _IO Interface_ class objects (_IO Interface_) are responsible for the communication between the stream (input, output, error) and the _Calculator Service_ class object (_Calculator Service_) and vise versa. |
| Calculator Services | `RealPage::Calculator::CalculatorService` `RealPage::Calculator::RPNCalculatorService`  | _Calculator Services_ are responsible for computing the input received from the _IO Interface_ and returning the result and/or any errors encountered back to the _IO Interface_.|

### Secondary Class Categories

| Secondary Class Category        | Example Class | High-Level Function |
|-------------:|:-------------|:------------------|
| Calculator Results | `RealPage::Calculator::CalculatorResults`  | _CalculatorResult_ class objects (_CalculatorResult_) are returned to the _IO Interace_ as a result of a _Calculator Service_ request initiated by the _IO Interface_. The _CalculatorResult_ contains the computed result and/or any error that may have been encountered during the request. |
| Input Parsers | `RealPage::Calculator::InputParser` `RealPage::Calculator::RPNInputParser`  | _InputParser_ class objects (_InputParser_) are used by _Calculator Services_ and responsible for parsing input received from an _IO Interface_ into a format suitable for processing by the _Calculator Service_. |
| Input Tokens | `RealPage::Calculator::InputToken`  | _InputToken_ class objects (_InputToken_) represent an individual, space delimited token received from the input stream. _InputToken_ is responsible for identifying the _nature_ and _type_ of the token it encapsulates. For example, _InputToken_ identifies the following token types: _operators_, _operands_ and _commands_; it also identifies whether or not a token is _valid_. |

### Support Classes/Modules

| Support Class/Module | High-Level Function |
|:-------------|:------------------|
| `RealPage::Calculator::Configuration`  | The _Configuration_ Singleton object (_Configuration_) is responsible for loading the _/calculator/config/calculator_service_config.yml_ file and providing a single(ton) interface to configuration settings user by _Calculator Services_. Configuration settings such as valid _operators_, _commands_ (i.e. as _quit_, _view stack_, _clear stack_) and _console_interface_options_ are made available through the _Configuration_ Singleton. |
| `RealPage::Calculator::I18nTranslator`  | The _i18n Tranclator_ Singleton object (_i18n Translator_) is responsible for loading the /configuration/config/i18n.yml file and providing a single(ton) interface for _translation_ services used by _IO Interfaces_. |
| `RealPage::Calculator::InterfaceNotReadyError` `RealPage::Calculator::MustOverrideError`  | The _Error_ class objects (_Errors_) are used throughout the RPC project wherever a custom error needs to be raised.|
| `RealPage::Calculator::Errors`  | The _Error Support_ module (_Error Support_) defines errors in the form of _Hash_ values. When the _Calculator Service_ encounters an error, a _CalculatorResult_ object is created and the _Error Support_ error is embedded in the _CalculatorResult_ object and sent to the _IO Interface_. The _Error Support_ error Hash embedded in the _CalculatorResult_ object is then used by the _IO Interface_ as input to the _i18n Translator_ ({key: :key, scope: :scope}) to return a locale specific error message to the output stream. |
| `RealPage::Calculator::ArrayExtension`  | The _Array Extensions_ extensions (_Array Extensions_) add convenience functionality to the Ruby _Array_ class in support of _InputToken_ array processing. |
| `RealPage::Calculator::ObjectExtension`  | The _Object Extensions_ extensions (_Object Extensions_) add convenience functionality to the Ruby _Object_ class in support of _InputToken_ array processing. |

### Configuration Files

| File        | High-Level Purpose |
|-------------:|:------------------|
| `/calculator/config/calculator.yml`  | The _Calculator Configuration_ file is used to configure _operators_ and command-line _commands_ that will be acknowledged by the _CalculatorServices_ and _IO Interfaces_, as well as options to configure specific _IO Interface_ behavior. |
| `/calculator/config/i18n.yml`  | The _i18n Configuration_ file provides locale-specific translation entries in the form of _key/scope pairs_ used by the _i18n Translator_ |

### Executable Command-Line Scripts

| Script        | Type | Purpose |
|-------------:|:------------------|:------------------|
| `/calculator/rpn_cal.rb`  | Ruby | The _Console RPN Calculator_ file is an _executable Ruby script_ that Users can use to run and interact with the RPN calculator in a UNIX-like CLI. |

## Technical/Architectural Reasoning

According to the [specification][specs], the RPC project was to create a _command-line, Reverse Polish Notation calculator for people who are comfortable with UNIX-like CLI utilities_. The specification also dictated that the initial project installment must implement the four basic calculator operators (+, -, /, *) and be designed in such a way as to allow for additional operators and interfaces (WebSocket, file or TCP Socket) to be added in the future. In addition to these, I took the liberty of presuming the possibility of _additional calculator types_ as well. Consequently, I sought to design this RPC project in such a way as to be (among other things): 
+ _Configurable_ (additional operators)
+ _Extensible_ (additional _IO Interfaces_, _Calculator Service_ types) 
+ _DRY_
+ _Testable_ 

From an _architectural perspective_, the RPC project consists of a series of what will be referred to (arbitrarily) as:
+ _Primary class categories_
+ _Secondary class categories_
+ _Support classes/modules_ 
+ _Executable command-line scripts_
 
The remainder of this section will give an overview of each, as well as the technical/architectural reasoning behind the same.

### Primary Class Categories

#### Classes
`RealPage::Calculator::CalculatorService` `RealPage::Calculator::RPNCalculatorService` `RealPage::Calculator::IOInterface` `RealPage::Calculator::ConsoleInterface`

#### Reasoning
_Primary class categories_ include _IO Interfaces_ and _Calculator Services_. Classes that derive from `RealPage::Calculator::IOInterface` and `RealPage::Calculator::CalculatorService`, respectfully, fall into these categories. _IO Interfaces_ and _Calculator Services_ are considered _Primary classes_ because these are the categories of classes Developers _and_ Users will interact with most often. 

##### IO Interface

The _IO Interface_ acts as a liaison between the _Calculator Service_ and the particular stream the _IO Interface_ represents. Consequently, the _IO Interface_ is also responsible for the format (plain text, json, xml, etc.) and translation any output sent to the output stream using i18n. 

##### Calculator Service

The _Calculator Service_ is a service responsible for accepting input from, and returning a result (computation or error) to, the _IO Interface_. Consequently, the _Calculator Service_, by implementing an _Input Parser_, is responsible for manipulating the raw input received from the _IO Interface_ into a format specific to its own needs, and returning the raw result (_CalculatorResult_ object) back to the _IO Interface_.

##### Interdependence

The _IO Interface_ and _Calculator Service_ are interdependent; therefore, they need to communicate with eachother. However, the _IO Interface_ and _Calculator Service_ have _distinct concerns_. As a result, the decision was made to create _two_ categories of classes - each concerned solely with its own, distinct, funcionality - maintaining a clear _separation of concern_. In addition to this, the decision was made to require that a `RealPage::Calculator::CalculatorService` object be provided when instantiating a `RealPage::Calculator::IOInterface` object. This _losely coupled relationship_ (as opposed to _Composition_) makes for a more _extensible_, _testable_, and potentially DRY framework, and opens up the ability for future non-RPN-based _Calculator Services_ to be implemented using existing _IO Interfaces_. Similar rationale and implementation can be witnessed between the _Calculator Service_ -> _Input Parser_ relationship (i.e. `RealPage::Calculator::CalculatorService`, `RealPage::Calculator::InputParser`)

### Secondary Class Categories

#### Classes
`RealPage::Calculator::CalculatorResult` `RealPage::Calculator::InputParser` `RealPage::Calculator::RPNInputParser` `RealPage::Calculator::InputToken`

#### Reasoning

##### Calculator Result

A _Calculator Result_ is returned via notification from a _Calculator Service_ to an _IO Service_ in response to a _Calculator Service_ request (e.g. `RealPage::Calculator::CalculatorService#compute`). A _Calculator Result_ object encapsulates a _Calculator Service_ computation or error encountered along with the offending token. _Calculator Result_ provides a standard container class for communicating results from the _Calculator Service_ to the _IO Interface_.

Encapsulating the result returned from a _Calculator Service_ (in a _Calculator Result_ object)  enforces a standard in the way _Calculator Services_ and _IO Interfaces_ exchange _Calculator Service_ results. _Calculator Result_ provides rudimentary methods to retrieve computed results and identify/retrieve errors when the occur (_single responsibility_). _Calculator Result_ can be easily extended to provide additional information or functionality should it be required by a future _Calculator Service_ or _IO Interface_. Finally, in addition to providing _extensibility_, _Calculator Result_ classes are _testable_, and its enforced use helps to maintain the DRY principle.

##### Input Parsers

_Input Parsers_ are used by _Calculator Services_. A `RealPage::Calculator::CalculatorService`, in fact, cannot be instantiated without providing an `RealPage::Calculator::InputParser`. _Input Parsers_ are responsible for parsing input received from an _IO Interface_ into a format suitable for processing by the _Calculator Service_. 

_Calculator Services_ have the _single responsibility_ of computing. Likewise, _Input Parsers_ have the _single responsibility_ of parsing input received from an _IO Interface_ into a format suitable for processing by the _Calculator Service_. _Input Parsers_ relieve the _Calculator Service_ of this burden by eliminating this concern. _Input Parsers_ help keep things DRY as they may be shared between _Calculator Services_ or _extended_. In addition to this, _Input Parsers_ provide better, isolated _testability_. 

##### Input Tokens

_Input Tokens_ are used by classes derived from `RealPage::Calculator::InputParser` and represent an individual, space delimited token received from the input stream. _Input Token_ is responsible for identifying the _nature_ and _type_ of the token it encapsulates. For example, _Input Token_ identifies the following token types: _operators_, _operands_ and _commands_; it also identifies whether or not a token is _valid_.

_Input Tokens_ exist to identify the _nature_ (`#empty?`, `#invalid?`, `#valid?`) and _type_ (`#command?`, `#operator?`, `#operand?`, `#quit?`, etc.) of each input token encountered; this relieves the other classes of this responsibility and makes for better _testability_. _Input Token_ provides the same class methods as the instance implementation so that input may be interrogated without the need to instantiate an _Input Token_ object.

### Support Classes/Modules 

#### Classes

`RealPage::Calculator::Configuration` `RealPage::Calculator::I18nTranslator` `RealPage::Calculator::InterfaceNotReadyError` `RealPage::Calculator::MustOverrideError`  `RealPage::Calculator::ArrayExtension` `RealPage::Calculator::ObjectExtension`

#### Modules

`RealPage::Calculator::Errors`

#### Reasoning

The functionality that each of these classes/modules provides is necessary to the RPC project. However, that doesn't justify the existance of any of these classes/modules in particular - this is true of any class/module in this project. In general, however, the justification for _these particular_ classes/modules _primarily_ includes the need to _separate the concern_ each class has from the rest of the application, and to limit this concern to a _single responsibility_. The _reason_ they are coded the way they are, depends on their individual _purpose_.

##### Configuration

The `RealPage::Calculator::Configuration` class provides application _configuration settings_. This is necessary to make the project more _dynamic_. For example, you should not have to change the program code in order to add a new operator, or change the value of the _quit_ command. It is a _Singleton_. It is also a Singleton because only one instance of this class ever needs to exist. This is because the data it makes available never changes after the class has been instantiated. It is not a _Module_, because it needs to load a yaml file as part of its instantiation processing and it makes the most sense to do this one time, during object instantiation. Modules do not get instantiated. This is not regular a _Class_ either, for slightly different reasons; it doesn't make sense to instantiate multiple objects of this types, only to have to load the yaml file over and over.

##### i18n

The `RealPage::Calculator::I18nTranslator` classes provides _i18n translation key/scope pairs_ used for text translation. This is necessary to provide localization. For example, if I speak Spanish and am using the RPN Calculator, I should see error messages in Spanish. It also is a _Singleton_ for the same reasons mentioned previously.

##### Errors Module

`RealPage::Calculator::Errors` is a _module_. Likewise, the data it makes available never changes; however, the data it makes available is static (not dependant upon loading a yaml file). Therefore, a Module makes the most sense.

##### Extensions

`RealPage::Calculator::ArrayExtension` and `RealPage::Calculator::ObjectExtension` are convenience extensions. `RealPage::Calculator::ArrayExtension` provides an extension to convert an Array of _InputTokens_ to an Array of _token_ values. `RealPage::Calculator::ObjectExtension` provides an extension to determine whether or not an object is nil? or empty? Both of these extensions are not justified, at least not as extensions. See [Technical/Architectural Reflections](#technicalarchitectural-reflections) for more detail.

##### Errors 

The `RealPage::Calculator::InterfaceNotReadyError` and `RealPage::Calculator::MustOverrideError` error classes provide custom errors where the standard Ruby errors fall short.

### Executable Command-Line Scripts 

#### Scripts

`/calculator/rpn_calc.rb`

#### Reasoning

The justification for this script is that Users need a simple script to run the RPN calculator from the command-line. This script enables users to do that without having to start _irb_ and instantiate 

## Technical/Architectural Reflections

There are a few things I would do differently if I spent more time on the project. The first thing I would do, is make this project a _Ruby gem_. A gem would enable this project to be distributed properly and easily incorporated into any Ruby or Rails application. In fact, I would most likely break the project up into multiple gems, for example, an _rpc_core_ gem and perhaps one gem for each additional _IO Interface_ type. This would also eliminate the need to hard-code yaml file names in the `RealPage::Calculator::Configuration` and `RealPage::Calculator::I81nTranslator` classes and probably eliminate these classes altogether in favor of Ruby standard config scripts.

Some of the other things I would do or do differently would be:

+ Create additional _IO Interfaces_, one for _file_, and one for _WebSocket_ (I've never use WebSocket before), then create a Rails app host and see how it works.
+ Refactor `RealPage::Calculator::CalculatorService` to allow _input stack_ as a param during initialization so the _Calculator Service_ state could be restored in a stateless environment, _HTTP Interface_ for example.
+ Move the convenience extensions found in `RealPage::Calculator::ArrayExtension` and `RealPage::Calculator::ObjectExtension` to a helper module to avoid any potential name collisions in consuming applications.
+ Provide a means of _setting_ (in the case of stateful environments) or _accepting_ (in the case of stateless environments) a locale to be used for localization.
+ Refactor `RealPage::Calculator::InputToken` into a base class by eliminating calculator-specific command methods (class and instance) and force _Calculator Services_ to implement their own, calculator-specific _InputToken_ class. It's not very extensible the way it is.
+ Refactor `RealPage::Calculator::InputParser` to allow a _token delimiter_ param during initialization to be used to parse and tokenize raw input; currently, only spaces are recognized.
+ Add a _help_ command to be associated with `RealPage::Calculator::RPNCalculatorService` that returns a lists all available commands and in the case of a _Console Interface_, displays help in a UNIX-like CLI fashion.

## Script Execution

There are two ways to run the RPN calculator using the console as the interface, _Rake task_ and _Ruby script_. The instructions for each are outlined below.

For your convenience, _view stack_ (v) and _clear stack_ \(c\) commands have been implemented. These RPN calculator commands allow you to _view the input stack_ and _clear the input stack_ respectfully.

### Rake Task

To run a version of the RPN calculator from the console using _Rake_, make sure you are in the project root directory (`/realpage_calculator`), then type the following command into the command-line followed by ENTER:

`$ rake console`

### Ruby Script

To run a version of the RPN calculator from the console using _Ruby script_, from the project root folder (`/realpage_calculator`), change to the `/calculator` folder by typing the following into the command-line followed by ENTER: 

`$ cd calculator`

Now type the following command into the command-line followed by ENTER to run the RPN calculator:

`$ ruby rpn_calc.rb`

#### Make the Script Permanently Executable

If you don't wish to have to type `$ ruby` followed by the the script name every time you run this script, from the `/calculator` folder, type the following into the command-line followed by ENTER:

`$ chmod 755 rpn_calc.rb`

You may now execute the `rpn_calc.rb` script by typing the following into the command-line followed by ENTER:

`$ ./rpn_calc.rb`

   [specs]: <https://gist.github.com/joedean/078a62b9ec03b38dfc519b3a5f168b07>
