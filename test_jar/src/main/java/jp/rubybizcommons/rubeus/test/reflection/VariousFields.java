package jp.rubybizcommons.rubeus.test.reflection;

public final class VariousFields {
    public volatile int publicVolatile;
    protected final int protectedFinal = 0;
    final int packageFinal = 0;
    private transient int privateTransientField;

    static public volatile int staticPublicVolatile;
    static protected final int staticProtectedFinal = 0;
    static final int staticPackageFinal = 0;
    static private transient int staticPrivateTransientField;
}
