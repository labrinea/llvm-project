// RUN: %clang_analyze_cc1 %s \
// RUN:   -analyzer-checker=core \
// RUN:   -analyzer-checker=unix.StdCLibraryFunctions \
// RUN:   -analyzer-config unix.StdCLibraryFunctions:DisplayLoadedSummaries=true \
// RUN:   -analyzer-checker=debug.ExprInspection \
// RUN:   -analyzer-config eagerly-assume=false \
// RUN:   -triple i686-unknown-linux 2>&1 | FileCheck %s

// CHECK: Loaded summary for: __size_t fread(void *restrict, size_t, size_t, FILE *restrict)

typedef typeof(sizeof(int)) size_t;
typedef struct FILE FILE;
size_t fread(void *restrict, size_t, size_t, FILE *restrict);

// Must have at least one call expression to initialize the summary map.
int bar(void);
void foo(void) {
  bar();
}
