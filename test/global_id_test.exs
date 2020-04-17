defmodule GlobalIdTest do
  use ExUnit.Case
  use PropCheck

  property "identical input creates identical output", numtests: 100_000 do
    forall [n1, n2, n3] <- [timestamp(), node_id(), serial()] do
      GlobalId.get_id(n1, n2, n3) == GlobalId.get_id(n1, n2, n3)
    end
  end

  describe "ids differ" do
    property "when timestamp differs", numtests: 100_000 do
      forall [n1, n2] <- [timestamp(), timestamp()] do
        implies n1 != n2 do
          GlobalId.get_id(n1, 1, 1) != GlobalId.get_id(n2, 1, 1)
        end
      end
    end

    property "when node_id differs", numtests: 1025 do
      forall [n1, n2] <- [node_id(), node_id()] do
        implies n1 != n2 do
          GlobalId.get_id(1, n1, 1) != GlobalId.get_id(1, n2, 1)
        end
      end
    end

    property "when serial differs", numtests: 2048 do
      forall [n1, n2] <- [serial(), serial()] do
        implies n1 != n2 do
          GlobalId.get_id(1, 1, n1) != GlobalId.get_id(1, 1, n2)
        end
      end
    end
  end

  describe "ids increase" do
    property "when timestamp increases", numtests: 100_000 do
      forall n <- timestamp() do
        GlobalId.get_id(n + 1, 1, 1) > GlobalId.get_id(n, 1, 1)
      end
    end

    property "when node_id increases", numtests: 1025 do
      forall n <- node_id() do
        implies n < 1024 do
          GlobalId.get_id(1, n + 1, 1) > GlobalId.get_id(1, n, 1)
        end
      end
    end

    property "when serial increases", numtests: 2048 do
      forall n <- serial() do
        implies n < 2046 do
          GlobalId.get_id(1, n + 1, 1) > GlobalId.get_id(1, n, 1)
        end
      end
    end
  end

  describe "serial rollover" do
    # This isn't necessarily desirable, but it happens so we test it
    test "when the serial is larger than 11 bits" do
      assert GlobalId.get_id(1, 1, 2048) == GlobalId.get_id(1, 1, 0)
      refute GlobalId.get_id(1, 1, 2048) == GlobalId.get_id(2, 1, 0)
    end
  end

  # Generators

  defp timestamp, do: non_neg_integer()
  defp node_id, do: range(0, 1024)
  defp serial, do: range(0, 2047)
end
