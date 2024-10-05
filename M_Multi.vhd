library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity matrix_multiplication is
    generic (
        N : integer := 3  -- Matrix size (N x N)
    );
    port (
        clk   : in std_logic;  -- Clock signal
        rst   : in std_logic;  -- Reset signal
        A     : in std_logic_vector(N*N-1 downto 0);  -- Matrix A (flattened 1D array)
        B     : in std_logic_vector(N*N-1 downto 0);  -- Matrix B (flattened 1D array)
        result: out std_logic_vector(N*N-1 downto 0)  -- Result matrix (flattened 1D array)
    );
end matrix_multiplication;

architecture Behavioral of matrix_multiplication is

    type matrix is array (0 to N-1, 0 to N-1) of integer;
    
    signal matA : matrix := ((others => (others => 0)));
    signal matB : matrix := ((others => (others => 0)));
    signal matC : matrix := ((others => (others => 0)));

begin

    -- Process to perform matrix multiplication
    process (clk, rst)
    begin
        if rst = '1' then
            matC <= (others => (others => 0));  -- Reset result matrix to zero
        elsif rising_edge(clk) then
            -- Unroll flattened matrix inputs into 2D arrays
            for i in 0 to N-1 loop
                for j in 0 to N-1 loop
                    matA(i, j) <= to_integer(unsigned(A((i*N + j)*8 + 7 downto (i*N + j)*8)));
                    matB(i, j) <= to_integer(unsigned(B((i*N + j)*8 + 7 downto (i*N + j)*8)));
                end loop;
            end loop;

            -- Perform matrix multiplication
            for i in 0 to N-1 loop
                for j in 0 to N-1 loop
                    matC(i, j) <= 0;  -- Initialize the result element
                    for k in 0 to N-1 loop
                        matC(i, j) <= matC(i, j) + (matA(i, k) * matB(k, j));
                    end loop;
                end loop;
            end loop;
        end if;
    end process;

    -- Flatten the 2D result matrix into 1D output
    process (matC)
    begin
        for i in 0 to N-1 loop
            for j in 0 to N-1 loop
                result((i*N + j)*8 + 7 downto (i*N + j)*8) <= std_logic_vector(to_unsigned(matC(i, j), 8));
            end loop;
        end loop;
    end process;

end Behavioral;

