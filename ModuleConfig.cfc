component {

    this.title         = "qb";
    this.author        = "Eric Peterson";
    this.webURL        = "https://github.com/elpete/qb";
    this.description   = "Query builder for the rest of us";
    this.version       = "5.0.0";
    this.autoMapModels = false;
    this.cfmapping     = "qb";

    function configure() {
        settings = {
            defaultGrammar = "BaseGrammar",
            returnFormat = "array"
        };

        interceptorSettings = {
            customInterceptionPoints = "preQBExecute,postQBExecute"
        };

        binder.map( "QueryUtils@qb" )
            .to( "qb.models.Query.QueryUtils" )
            .asSingleton();
    }

    function onLoad() {
        var interceptorService = ( structKeyExists( application, "applicationName" ) && application.applicationName == "CommandBox CLI" ) ?
            binder.getInjector().getInstance( "shell" ).getInterceptorService() :
            binder.getInjector().getInstance( dsl = "coldbox:interceptorService" );

        binder.map( "BaseGrammar@qb" )
            .to( "qb.models.Grammars.BaseGrammar" )
            .property( name = "interceptorService", value = interceptorService )
            .asSingleton();

        binder.map( "MySQLGrammar@qb" )
            .to( "qb.models.Grammars.MySQLGrammar" )
            .property( name = "interceptorService", value = interceptorService )
            .asSingleton();

        binder.map( "OracleGrammar@qb" )
            .to( "qb.models.Grammars.OracleGrammar" )
            .property( name = "interceptorService", value = interceptorService )
            .asSingleton();

        binder.map( "MSSQLGrammar@qb" )
            .to( "qb.models.Grammars.MSSQLGrammar" )
            .property( name = "interceptorService", value = interceptorService )
            .asSingleton();

        binder.map( "QueryBuilder@qb" )
            .to( "qb.models.Query.QueryBuilder" )
            .initArg( name = "grammar", ref = "#settings.defaultGrammar#@qb" )
            .initArg( name = "utils", ref = "QueryUtils@qb" )
            .initArg( name = "returnFormat", value = settings.returnFormat );

        binder.map( "SchemaBuilder@qb" )
            .to( "qb.models.Schema.SchemaBuilder" )
            .initArg( name = "grammar", ref = "#settings.defaultGrammar#@qb" );
    }

}
