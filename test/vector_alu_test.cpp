
#include <gtest/gtest.h>

#include <cstdint>
#include <stdexcept>

#include "processor/alu.h"

using Kites::alu::Alu;
using Kites::alu::AluOp;

TEST(VectorAluTest, AddsTwoFloatLanes) {
    // Lane 0: 1.5 + 2.5 = 4.0
    // Lane 1: 10.0 + 3.0 = 13.0
    const std::uint64_t a = 0x412000003FC00000ULL;
    const std::uint64_t b = 0x4040000040200000ULL;

    const auto result =
        Alu::executeVector32(AluOp::VADD, 0, a, b);

    EXPECT_EQ(result, 0x4150000040800000ULL);
}

TEST(VectorAluTest, SubtractsTwoFloatLanes) {
    // Lane 0: 1.5 - 2.5 = -1.0
    // Lane 1: 10.0 - 3.0 = 7.0
    const std::uint64_t a = 0x412000003FC00000ULL;
    const std::uint64_t b = 0x4040000040200000ULL;

    const auto result =
        Alu::executeVector32(AluOp::VSUB, 0, a, b);

    EXPECT_EQ(result, 0x40E00000BF800000ULL);
}


TEST(VectorAluTest, MultipliesTwoFloatLanes) {
    // Lane 0: 1.5 * 2.5 = 3.75
    // Lane 1: 10.0 * 3.0 = 30.0
    const std::uint64_t a = 0x412000003FC00000ULL;
    const std::uint64_t b = 0x4040000040200000ULL;

    const auto result =
        Alu::executeVector32(AluOp::VMUL, 0, a, b);

    EXPECT_EQ(result, 0x41F0000040700000ULL);
}

TEST(VectorAluTest, SwapsTwoFloatLanes) {
    // Lane 0 (lower) = 1.5, lane 1 (upper) = 10.0
    const std::uint64_t a = 0x412000003FC00000ULL;

    const auto result =
        Alu::executeVector32(AluOp::VSWAP, 0, a, 0);

    // Lane 0 = 10.0, lane 1 = 1.5
    EXPECT_EQ(result, 0x3FC0000041200000ULL);
}

TEST(VectorAluTest, SwapsLanesRegardlessOfDestination) {
    const std::uint64_t destination = 0xDEADBEEFCAFEBABEULL;
    const std::uint64_t a = 0x412000003FC00000ULL;

    const auto result =
        Alu::executeVector32(AluOp::VSWAP, destination, a, 0);

    // VSWAP replaces both lanes, so the old destination is ignored.
    EXPECT_EQ(result, 0x3FC0000041200000ULL);
}

TEST(VectorAluTest, SwapsZeroAndNonzeroLanes) {
    const std::uint64_t a = 0x000000003F800000ULL;

    const auto result =
        Alu::executeVector32(AluOp::VSWAP, 0, a, 0);

    EXPECT_EQ(result, 0x3F80000000000000ULL);
}

TEST(VectorAluTest, RejectsVSwapWithInvalidActiveLaneCount) {
    EXPECT_THROW(
        Alu::executeVector32(AluOp::VSWAP, 0, 0, 0, 1, 0b11),
        std::invalid_argument);
}

TEST(VectorMemoryTest, Stores64BitVectorRegister) {
    // Example packed vector value:
    // Lane 0 = 1.5, lane 1 = 10.0
    const std::uint64_t vectorValue = 0x412000003FC00000ULL;

    // Set up your processor and memory using your existing test fixture.
    // Write vectorValue into vector register v3.
    // Execute: vsd v3, 0(x10), with x10 pointing to a valid memory address.

    // After executing VSD, verify the 8 bytes at that address
    // reconstruct the original 64-bit value.
    //
    // EXPECT_EQ(memory_controller.readDoubleWord(address), vectorValue);
}

TEST(VectorAluTest, PreservesInactiveDestinationLane) {
    // Destination: upper lane = 10.0, lower lane = 1.0
    const std::uint64_t destination = 0x412000003F800000ULL;

    // Both lanes contain 2.0 in each operand.
    const std::uint64_t a = 0x4000000040000000ULL;
    const std::uint64_t b = 0x4000000040000000ULL;

    // Mask 0b01 enables lane 0 only.
    const auto result = Alu::executeVector32(
        AluOp::VADD, destination, a, b, 2, 0b01);

    // Lane 0 = 4.0; lane 1 remains 10.0.
    EXPECT_EQ(result, 0x4120000040800000ULL);
}

TEST(VectorAluTest, ZeroActiveLanesPreservesDestination) {
    const std::uint64_t destination = 0x123456789ABCDEF0ULL;

    const auto result = Alu::executeVector32(
        AluOp::VADD, destination, 0, 0, 0, 0b11);

    EXPECT_EQ(result, destination);
}

TEST(VectorAluTest, RejectsInvalidActiveLaneCount) {
    EXPECT_THROW(
        Alu::executeVector32(AluOp::VADD, 0, 0, 0, 3, 0b11),
        std::invalid_argument);
}

TEST(VectorAluTest, RejectsInvalidMask) {
    EXPECT_THROW(
        Alu::executeVector32(AluOp::VADD, 0, 0, 0, 2, 0b100),
        std::invalid_argument);
}

TEST(VectorAluTest, RejectsUnsupportedOperation) {
    EXPECT_THROW(
        Alu::executeVector32(AluOp::VMUL, 0, 0, 0),
        std::invalid_argument);
}
