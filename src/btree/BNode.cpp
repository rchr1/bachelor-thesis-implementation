#include "BNode.h"
// --------------------------------------------------------------------------
namespace {
// --------------------------------------------------------------------------
btree::BNodeWrapper<std::uint64_t, std::uint64_t, 4096> node(false);
// the node should fit on the page
static_assert(sizeof(node) == 4096);
// --------------------------------------------------------------------------
}// namespace
 // --------------------------------------------------------------------------