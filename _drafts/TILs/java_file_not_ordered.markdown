`Java.io.file.listFiles` does not guarantee file order. On my mac files are ordered alphabetically, however when deployed they are not anymore. Clojure's `file-seq` behaves accordingly.
