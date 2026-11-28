package rw.flipper

/**
 * Holds at most one value for the life of the process.
 *
 * [obtain] builds the value on first use and returns that same value after.
 * [release] forgets it, but only while it is still the one held, so a late
 * release of an old value can't drop a newer one.
 */
internal class ProcessSlot<T : Any> {
    private var value: T? = null

    @Synchronized
    fun obtain(create: () -> T): T = value ?: create().also { value = it }

    @Synchronized
    fun peek(): T? = value

    @Synchronized
    fun release(held: T) {
        if (value === held) value = null
    }
}
