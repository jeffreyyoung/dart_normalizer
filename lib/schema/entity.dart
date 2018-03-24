import 'package:dart_normalizer/schema/immutable_utils.dart' as ImmutableUtils;


class EntitySchema {
  String key;
  var idAttribute = 'id';
  var _getId;
  var _mergeStrategy;
  var _processStrategy;
  var schema;


  var getDefaultGetId = (idAttribute) => (input, paremt, key) => input[idAttribute];

  EntitySchema(this.key, {definition, options, idAttribute}) {
    if (key == null) {
      throw new Exception();
    }

    var mergeStrategy = (entityA, entityB) {
      return {entityA: [entityA], entityA: [entityB]};
    };
    var processStrategy = (input) => ([input]);
   if (idAttribute == null) {
      // this.idAttribute = "id";
       this._getId = getDefaultGetId("id");
    }
    else {
      this._getId = idAttribute is String
          ? getDefaultGetId(idAttribute)
          : idAttribute;
    }
    this._mergeStrategy = mergeStrategy;
    this._processStrategy = processStrategy;
    this.define(definition);
  }


  define(Map definition) {
    if (definition != null) {
      this.schema = definition.map((key, value) {
        final schema = definition[key];
        return MapEntry(key, schema);
      });
    }
    if (schema == null) {
      this.schema = {};
    }
  }


  merge(entityA, entityB) {
    return this._mergeStrategy(entityA, entityB);
  }

  normalize(input, parent, key, visit, addEntity) {
    final processedEntity = input; // this._processStrategy(input, parent, key);
    /*(this.schema.keys).forEach((key) {
      if (processedEntity.containsKey(key) && processedEntity[key] is Map) {
        final schema = this.schema[key];
        processedEntity[key] = visit(
            processedEntity[key], processedEntity, key, schema, addEntity);
      }
    });*/
    addEntity(this, input, input, parent, key);
    print("normalize");
    return getId(input, parent, key);
  }

  getId(input, parent, key) {
    return this._getId(input, parent, key);
  }

}


