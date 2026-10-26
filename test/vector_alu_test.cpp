
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
