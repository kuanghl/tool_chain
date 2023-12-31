//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// <string>

// template<class charT, class traits, class Allocator>
//   basic_string<charT,traits,Allocator>
//   operator+(const basic_string<charT,traits,Allocator>& lhs, charT rhs); // constexpr since C++20

// template<class charT, class traits, class Allocator>
//   basic_string<charT,traits,Allocator>&&
//   operator+(basic_string<charT,traits,Allocator>&& lhs, charT rhs); // constexpr since C++20

#include <string>
#include <utility>
#include <cassert>

#include "test_macros.h"
#include "min_allocator.h"

template <class S>
TEST_CONSTEXPR_CXX20 void test0(const S& lhs, typename S::value_type rhs, const S& x) {
  assert(lhs + rhs == x);
}

#if TEST_STD_VER >= 11
template <class S>
TEST_CONSTEXPR_CXX20 void test1(S&& lhs, typename S::value_type rhs, const S& x) {
  assert(std::move(lhs) + rhs == x);
}
#endif

template <class S>
TEST_CONSTEXPR_CXX20 void test_string() {
  test0(S(""), '1', S("1"));
  test0(S(""), '1', S("1"));
  test0(S("abcde"), '1', S("abcde1"));
  test0(S("abcdefghij"), '1', S("abcdefghij1"));
  test0(S("abcdefghijklmnopqrst"), '1', S("abcdefghijklmnopqrst1"));

#if TEST_STD_VER >= 11
  test1(S(""), '1', S("1"));
  test1(S("abcde"), '1', S("abcde1"));
  test1(S("abcdefghij"), '1', S("abcdefghij1"));
  test1(S("abcdefghijklmnopqrst"), '1', S("abcdefghijklmnopqrst1"));
#endif
}

TEST_CONSTEXPR_CXX20 bool test() {
  test_string<std::string>();
#if TEST_STD_VER >= 11
  test_string<std::basic_string<char, std::char_traits<char>, min_allocator<char> > >();
#endif

  return true;
}

int main(int, char**) {
  test();
#if TEST_STD_VER > 17
  static_assert(test());
#endif

  return 0;
}
