package rw.flipper

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotSame
import org.junit.Assert.assertNull
import org.junit.Assert.assertSame
import org.junit.Test

class ProcessSlotTest {
    private class Engine

    @Test
    fun `a second activity gets the engine the first one built`() {
        val slot = ProcessSlot<Engine>()
        var built = 0
        val first = slot.obtain { built++; Engine() }
        val second = slot.obtain { built++; Engine() }

        assertSame(first, second)
        assertEquals(1, built)
        assertSame(first, slot.peek())
    }

    @Test
    fun `nothing is held before the first activity`() {
        assertNull(ProcessSlot<Engine>().peek())
    }

    @Test
    fun `a destroyed engine is replaced by a new one`() {
        val slot = ProcessSlot<Engine>()
        val first = slot.obtain { Engine() }

        slot.release(first)

        assertNull(slot.peek())
        val next = slot.obtain { Engine() }
        assertSame(next, slot.peek())
        assertNotSame(first, next)
    }

    @Test
    fun `a late release of an old engine keeps the newer one`() {
        val slot = ProcessSlot<Engine>()
        val old = slot.obtain { Engine() }
        slot.release(old)
        val current = slot.obtain { Engine() }

        slot.release(old)

        assertSame(current, slot.peek())
    }
}
