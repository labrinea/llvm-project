//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// UNSUPPORTED: c++03

// <forward_list>

// void swap(forward_list& c)
//     noexcept(!allocator_type::propagate_on_container_swap::value ||
//              __is_nothrow_swappable<allocator_type>::value);          // constexpr since C++26
//
//  In C++17, the standard says that swap shall have:
//     noexcept(is_always_equal<allocator_type>::value);                 // constexpr since C++26

// This tests a conforming extension

#include <forward_list>
#include <utility>
#include <cassert>

#include "test_macros.h"
#include "MoveOnly.h"
#include "test_allocator.h"

template <class T>
struct some_alloc {
  typedef T value_type;

  some_alloc() {}
  some_alloc(const some_alloc&);
  void allocate(std::size_t);
  void deallocate(void*, unsigned) {}

  typedef std::true_type propagate_on_container_swap;
};

template <class T>
struct some_alloc2 {
  typedef T value_type;

  some_alloc2() {}
  some_alloc2(const some_alloc2&);
  void allocate(std::size_t);
  void deallocate(void*, unsigned) {}

  typedef std::false_type propagate_on_container_swap;
  typedef std::true_type is_always_equal;
};

void f() {
  {
    typedef std::forward_list<MoveOnly> C;
    static_assert(noexcept(swap(std::declval<C&>(), std::declval<C&>())), "");
  }
#if defined(_LIBCPP_VERSION)
  {
    typedef std::forward_list<MoveOnly, test_allocator<MoveOnly>> C;
    static_assert(noexcept(swap(std::declval<C&>(), std::declval<C&>())), "");
  }
  {
    typedef std::forward_list<MoveOnly, other_allocator<MoveOnly>> C;
    static_assert(noexcept(swap(std::declval<C&>(), std::declval<C&>())), "");
  }
#endif // _LIBCPP_VERSION
  {
    typedef std::forward_list<MoveOnly, some_alloc<MoveOnly>> C;
#if TEST_STD_VER >= 14
    //  In C++14, if POCS is set, swapping the allocator is required not to throw
    static_assert(noexcept(swap(std::declval<C&>(), std::declval<C&>())), "");
#else
    static_assert(!noexcept(swap(std::declval<C&>(), std::declval<C&>())), "");
#endif
  }
#if TEST_STD_VER >= 14
  {
    typedef std::forward_list<MoveOnly, some_alloc2<MoveOnly>> C;
    //  if the allocators are always equal, then the swap can be noexcept
    static_assert(noexcept(swap(std::declval<C&>(), std::declval<C&>())), "");
  }
#endif
}
