# clippings
Parser for Kindle clippings.

Example:
```fish
idris -p lightyear -i src src/Text/Kindle/Clippings.idr
```

```idris
*src/Text/Kindle/Clippings> catMaybes <$> parse (some clipping) examples
Right [Clip (Doc "Erlang and OTP in Action"
                 (Just "Martin Logan, Eric Merritt, Richard Carlsson"))
            (Loc (Singleton 3839))
            (MkDate Wednesday August 12 2015)
            Bookmark,
       Clip (Doc "Building Web Applications with Erlang"
                 (Just "Zachary Kessin"))
            (PPLoc (Singleton 22) (Singleton 308))
            (MkDate Wednesday August 13 2014)
            (Note "This is kind of like built-in mongroup.")]
```
