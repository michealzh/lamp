
- java byte 数组拼接

```java
private byte[] concatByteArrays(byte[] a, byte[] b) {
  byte[] c = new byte[a.length + b.length];
  System.arraycopy(a, 0, c, 0, a.length);
  System.arraycopy(b, 0, c, a.length, b.length);
  return c;
}

//https://guava.dev/releases/19.0/api/docs/com/google/common/primitives/Bytes.html#concat(byte%5B%5D...)
byte[] c = Bytes.concat(a, b);

```
