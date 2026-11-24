#include <gtest/gtest.h>
#include <cstdint>
#include <stdexcept>
#include <vector>

#include "processor/registers.h"

using Kites::RegisterFile;


TEST(VectorRegistersTest, ReadsAndWritesAllEightRegisters) {
    RegisterFile registers;

    for (std::size_t i = 0; i < 8; ++i) {
        const std::uint64_t value =
            0x123456789ABCDEF0ULL + i;

        registers.WriteVpr(i, value);

        EXPECT_EQ(registers.ReadVpr(i), value);
    }
}

TEST(VectorRegistersTest, RegistersStoreIndependentValues) {
    RegisterFile registers;

    registers.WriteVpr(0, 0x1111111111111111ULL);
    registers.WriteVpr(1, 0x2222222222222222ULL);

    EXPECT_EQ(registers.ReadVpr(0), 0x1111111111111111ULL);
    EXPECT_EQ(registers.ReadVpr(1), 0x2222222222222222ULL);
}

TEST(VectorRegistersTest, RejectsInvalidRegisterIndices) {
    RegisterFile registers;

    EXPECT_THROW(registers.ReadVpr(8), std::out_of_range);
    EXPECT_THROW(registers.WriteVpr(8, 123), std::out_of_range);
}

TEST(VectorRegistersTest, ReturnsAllVectorRegisterValues) {
    RegisterFile registers;

    for (std::size_t i = 0; i < 8; ++i) {
        registers.WriteVpr(i, 100 + i);
    }

    const auto values = registers.GetVprValues();

    ASSERT_EQ(values.size(), 8u);

    for (std::size_t i = 0; i < 8; ++i) {
        EXPECT_EQ(values[i], 100 + i);
    }
}

TEST(VectorRegistersTest, ResetClearsVectorRegisters) {
    RegisterFile registers;

    for (std::size_t i = 0; i < 8; ++i) {
        registers.WriteVpr(i, 0xFFFFFFFFFFFFFFFFULL);
    }

    registers.Reset();

    for (std::size_t i = 0; i < 8; ++i) {
        EXPECT_EQ(registers.ReadVpr(i), 0ULL);
    }
}
