# cython: preliminary_late_includes_cy28=True
#*****************************************************************************
#  cysignals is free software: you can redistribute it and/or modify it
#  under the terms of the GNU Lesser General Public License as published
#  by the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  cysignals is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Lesser General Public License for more details.
#
#  You should have received a copy of the GNU Lesser General Public License
#  along with cysignals.  If not, see <http://www.gnu.org/licenses/>.
#
#*****************************************************************************

# Auto-generated file setting the correct include directories
cimport cysignals.__init__
from libc.signal cimport sig_atomic_t
from cpython.object cimport PyObject

cdef extern from *:
    int unlikely(int) nogil  # Defined by Cython


cdef extern from "struct_signals.h":
    ctypedef struct cysigs_t:
        sig_atomic_t sig_on_count
        const char* s
        PyObject* exc_value


cdef extern from "macros.h" nogil:
    int sig_on() except 0
    int sig_str(const char*) except 0
    int sig_check() except 0
    void sig_off()
    void sig_retry()  # Does not return
    void sig_error()  # Does not return
    void sig_block()
    void sig_unblock()

    # Macros behaving exactly like sig_on, sig_str and sig_check but
    # which are *not* declared "except 0".  This is useful if some
    # low-level Cython code wants to do its own exception handling.
    int sig_on_no_except "sig_on"()
    int sig_str_no_except "sig_str"(const char*)
    int sig_check_no_except "sig_check"()


# This function does nothing, but it is declared cdef except *, so it
# can be used to make Cython check whether there is a pending exception
# (PyErr_Occurred() is non-NULL). To Cython, it will look like
# cython_check_exception() actually raised the exception.
cdef inline void cython_check_exception() nogil except *:
    pass


cdef void verify_exc_value()

cdef inline PyObject* sig_occurred():
    """
    Borrowed reference to the exception which is currently being
    propagated from cysignals. If there is no exception or if we
    are done handling the exception, return ``NULL``.

    This is meant for Cython code to check whether objects may be in
    an invalid state. Typically, this would be used in an ``except``
    or ``finally`` block or in ``__dealloc__``.

    The implementation is based on reference counting: it checks whether
    the exception has been deleted. This means that it will break if the
    exception is stored somewhere. Note that weak references to
    exceptions are not allowed, so we do not need to worry about that.
    """
    if unlikely(cysigs.exc_value is not NULL):
        verify_exc_value()
    return cysigs.exc_value


# Variables and functions which are implemented in implementation.c
# and used by macros.h. We use the Cython cimport mechanism to make
# these available to every Cython module cimporting this file.
cdef nogil:
    cysigs_t cysigs "cysigs"
    void _sig_on_interrupt_received "_sig_on_interrupt_received"()
    void _sig_on_recover "_sig_on_recover"()
    void _sig_off_warning "_sig_off_warning"(const char*, int)
    void print_backtrace "print_backtrace"()


cdef inline void __generate_declarations():
    cysigs
    _sig_on_interrupt_received
    _sig_on_recover
    _sig_off_warning
    print_backtrace
