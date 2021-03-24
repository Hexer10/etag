Create simple HTTP ETags

Highly inspired from https://github.com/jshttp/etag , almost all the code and the documentation is taken from that project, all I did was to port the project over to dart.

## API

### etag(entity, {bool? weak})

Generate a strong ETag for the given entity. This should be the complete
body of the entity. Strings, `Uint8List`s, and `FileStat` are accepted. By
default, a strong ETag is generated except for `FileStat`, which will
generate a weak ETag (this can be overwritten by `weak`).

##### weak

Specifies if the generated ETag will include the weak validator mark (that
is, the leading `W/`). The actual entity tag is the same. The default value
is `false`, unless the `entity` is `fs.Stats`, in which case it is `true`.

