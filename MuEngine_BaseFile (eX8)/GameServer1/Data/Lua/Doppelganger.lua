-- ���ð��� Lua ��ũ��Ʈ


-- ���ð��� ���� ���� �ʱ�ȭ �Լ�
-- FN_LuaSetDoppelgangerInit()
-- ������� �ְ� ������ ������
-- LuaGetMaxUserLevel()
-- ������� ���� ������ ������
-- LuaGetMinUserLevel()
-- ���� HP ����
-- LuaSetMonsterHp(monsterIndex, HP)
-- ���� ���� �ð� ����
-- LuaSetAddMonsterTime(Second)
-- ���� ����Ȯ��
-- LuaSetMonsterAttackRate(Rate)
-- �̺�Ʈ �غ�ð�
-- LuaSetReadyTime(Minute)
-- �̺�Ʈ ����ð�
-- LuaSetPlayTime(Minute)
-- ���� �޴� �ð�
-- LuaSetEndTime(Minute)


local classDoppelgangerLua = CDoppelgangerLua()

--//////////////////////////////////////////////////////////////////////////////
-- ���ð��� �� ���� �ʱ�ȭ
--//////////////////////////////////////////////////////////////////////////////
function FN_LuaDopplegangerInit()
	-- �غ�ð�(��)
	classDoppelgangerLua:LuaSetReadyTime(1)
	-- ����ð�(��)
	classDoppelgangerLua:LuaSetPlayTime(10)
	-- ����޴½ð�(��)
	classDoppelgangerLua:LuaSetEndTime(1)
end


--//////////////////////////////////////////////////////////////////////////////
-- Callback �ֱ������� ȣ��
--//////////////////////////////////////////////////////////////////////////////
function FN_LuaDoppelgangerCallback(nCurTime)
	-- ������ �ð�
	--local nCurTime 			= classDoppelgangerLua:LuaGetLocalTime()

	-- �̺�Ʈ ���۽ð�
	local nStateTime		= classDoppelgangerLua:LuaGetStateTime()
	-- ���ӽ��� �� �����ð� (�и�������)
	local nPlayTime 		= (nCurTime - nStateTime) / 1000
	-- ���� ���� �ð�
	local nAddHerdMonsterTime = nCurTime
	--local nAddBossMonsterTime = nCurTime
	-- ���̽���Ŀ��������
	local bIceWorkerRegen	= 0

	nAddHerdMonsterTime 	= classDoppelgangerLua:LuaGetAddHerdMonsterTime()
	--nAddBossMonsterTime 	= classDoppelgangerLua:LuaGetAddBossMonsterTime()
	local nBossRegenOrder	= classDoppelgangerLua:LuaGetBossRegenOrder()

	-- �ʹ�ȣ
	local nMapNumber = classDoppelgangerLua:LuaGetMapNumber()

	local nHerdIndex = -1

	-- ���� ���͸� ����
	if (nCurTime - nAddHerdMonsterTime) >= 3 * 1000 then

		-- ���� ���� �ε����� ����
		nHerdIndex = classDoppelgangerLua:LuaGetMonsterHerdIndex()
		if nHerdIndex == -1 then
			return
		end

		-- ���� ���� ������ġ ����
		classDoppelgangerLua:LuaSetHerdStartPosInfo(nHerdIndex, 0, 1)
		-- ���� ���� ������ġ ����
		classDoppelgangerLua:LuaSetHerdEndPosInfo(nHerdIndex, 0)

		-- ���� ���͸� �߰���
		FN_LuaAddHerdMonster(nCurTime, nStateTime, nHerdIndex)

		-- ���� �ʰ� ���������� �� �����ڴ� �ٽ� ����
		local nKillerBossState = classDoppelgangerLua:LuaGetBossMonsterState()
		if nKillerBossState == 3 then
			FN_LuaAddMiddleBossMonster(nCurTime, nStateTime, nHerdIndex, 0)
		end

		-- ���� �ʰ� ���������� �� �г��� �����ڴ� �ٽ� ����
		local nAngerKillerBossState = classDoppelgangerLua:LuaGetLastBossMonsterState()
		if nAngerKillerBossState == 3 then
			FN_LuaAddLastBossMonster(nCurTime, nStateTime, nHerdIndex, 0)
		end

		-- ���� ���� ���� �ð� ����
		classDoppelgangerLua:LuaSetAddHerdMonsterTime(nCurTime)

	end

	-- ������ȣ�� �ȹ޾����� ����
	if nHerdIndex == -1 then
		return
	end

	--DebugPrint('nBossRegenOrder', nBossRegenOrder)

	-- ������ ���� ����
	if nBossRegenOrder == 0 and nPlayTime >= 1 * 60 then
		-- 1�� ��
		classDoppelgangerLua:LuaSetBossMonsterState(1)
		FN_LuaAddMiddleBossMonster(nCurTime, nStateTime, nHerdIndex, 1)
		classDoppelgangerLua:LuaSetBossRegenOrder(nBossRegenOrder+1)
	elseif nBossRegenOrder == 1 and nPlayTime >= 4 * 60 then
		-- 4�� ��
		classDoppelgangerLua:LuaSetBossMonsterState(1)
		FN_LuaAddMiddleBossMonster(nCurTime, nStateTime, nHerdIndex, 1)
		classDoppelgangerLua:LuaSetBossRegenOrder(nBossRegenOrder+1)
	elseif nBossRegenOrder == 2 and nPlayTime >= 6 * 60 then
		-- 6�� �� ���̽� ��Ŀ�� ������Ų��
		bIceWorkerRegen	= 1
		classDoppelgangerLua:LuaSetBossRegenOrder(nBossRegenOrder+1)
	elseif nBossRegenOrder == 3 and nPlayTime >= 7 * 60 then
		-- 7�� ��
		classDoppelgangerLua:LuaSetLastBossMonsterState(1)
		FN_LuaAddLastBossMonster(nCurTime, nStateTime, nHerdIndex, 1)
		classDoppelgangerLua:LuaSetBossRegenOrder(nBossRegenOrder+1)
	end


	-- ������ ���� ���͸� ������
	classDoppelgangerLua:LuaMonsterHerdStart(nHerdIndex)

	-- ���̽� ��Ŀ ������ ���⼭
	if bIceWorkerRegen == 1 then
		-- ���� ���� �ε����� ����
		local nHerdIndex = classDoppelgangerLua:LuaGetMonsterHerdIndex()
		if nHerdIndex == -1 then
			return
		end

		-- ��ġ�� ����
		local nPosInfo = classDoppelgangerLua:LuaGetRandomValue(16) + 3
		-- ���� ���� ������ġ ����
		classDoppelgangerLua:LuaSetHerdStartPosInfo(nHerdIndex, nPosInfo, 0)
		-- ���� ���� ������ġ ����
		classDoppelgangerLua:LuaSetHerdEndPosInfo(nHerdIndex, nPosInfo)

		-- ���̽���Ŀ�� �����Ѵٰ� �˸�
		classDoppelgangerLua:LuaIceworkerRegen(nPosInfo)

		-- ���̽���Ŀ ����
		FN_LuaAddIceWorkerMonster(nCurTime, nStateTime, nHerdIndex)

		-- ������ ���� ���͸� ������
		classDoppelgangerLua:LuaMonsterHerdStart(nHerdIndex)

		bIceWorkerRegen = 0
	end

end

--//////////////////////////////////////////////////////////////////////////////
-- �Ϲ� ���͸� �߰��Ѵ�
--//////////////////////////////////////////////////////////////////////////////
function FN_LuaAddHerdMonster(nCurTime, nStateTime, nHerdIndex)
	-- �ְ� ������ ������ �´�
	--local nMaxUserLevel	= classDoppelgangerLua:LuaGetMaxUserLevel()
	-- ������ �̿� ������ Hp�� ���
	--local nMonsterHp = nMaxUserLevel --* 10
	-- ���ӽ��� �� �����ð� (�и�������)
	local nPlayTime = nCurTime - nStateTime
	-- �ʹ�ȣ
	local nMapNumber = classDoppelgangerLua:LuaGetMapNumber()

	-- ���� ���ݷ� (�ּҰ��·� = nMonsterAtt * 0.8)
	--local nMonsterAtt 	= nMaxUserLevel + 100
	-- ���� ����
	--local nMonsterDef 	= nMaxUserLevel + 100

	-- ���� ���� ����
	local nMonsterCount = 1

	if nPlayTime < 3 * 60 * 1000 then
		nMonsterCount = 1
	elseif nPlayTime < 6 * 60 * 1000  then
		nMonsterCount = 2
	else
		nMonsterCount = 3
	end

	nMonsterCount = nMonsterCount + classDoppelgangerLua:LuaGetUserCount() - 1

	-- nMonsterCount ��ŭ ���� �߰�
	for cnt = 0, nMonsterCount-1 do
		local nMonsterIndex = 533 + classDoppelgangerLua:LuaGetRandomValue(6)
		--local nMonsterIndex = 531 + classDoppelgangerLua:LuaGetRandomValue(9)
		--local nMonsterIndex = 530
		local nAttackFirst	= 0

		if classDoppelgangerLua:LuaGetRandomValue(1000) < 700 then
		--if classDoppelgangerLua:LuaGetRandomValue(10000) < 1000 then
			nAttackFirst = 1
		end

		-- ���ð��� �ϰ��� ������ �������(����)
		if nMonsterIndex == 533 then
			nAttackFirst = 1
		end

		-- ��ũ�ε��� ��� ���˻�� �ٲ�
		if nMonsterIndex == 538 then
			nMonsterIndex = 539
		end

		classDoppelgangerLua:LuaAddMonsterHerd(nHerdIndex, nMonsterIndex, nAttackFirst)
	end
end

--//////////////////////////////////////////////////////////////////////////////
-- �߰����� ���͸� �߰��Ѵ�
--//////////////////////////////////////////////////////////////////////////////
function FN_LuaAddMiddleBossMonster(nCurTime, nStateTime, nHerdIndex, nFlag)
	-- �ְ� ������ ������ �´�
	--local nMaxUserLevel	= classDoppelgangerLua:LuaGetMaxUserLevel()
	-- ������ �̿� ������ Hp�� ���
	--local nMonsterHp = nMaxUserLevel --* 10
	-- ���ӽ��� �� �����ð� (�и�������)
	local nPlayTime = nCurTime - nStateTime
	-- �ʹ�ȣ
	local nMapNumber = classDoppelgangerLua:LuaGetMapNumber()

	-- ���� ���ݷ� (�ּҰ��·� = nMonsterAtt * 0.8)
	--local nMonsterAtt 	= nMaxUserLevel + 100
	-- ���� ����
	--local nMonsterDef 	= nMaxUserLevel + 100

	local nMonsterIndex = 530	-- ������
	local nAttackFirst	= 0
	classDoppelgangerLua:LuaAddMonsterHerd(nHerdIndex, nMonsterIndex, nAttackFirst)

	if nFlag == 1 then
		nMonsterIndex 	= 538	-- ��ũ�ε�
		nAttackFirst	= 1
		classDoppelgangerLua:LuaAddMonsterHerd(nHerdIndex, nMonsterIndex, nAttackFirst)
	end
end

--//////////////////////////////////////////////////////////////////////////////
-- �������� ���͸� �߰��Ѵ�
--//////////////////////////////////////////////////////////////////////////////
function FN_LuaAddLastBossMonster(nCurTime, nStateTime, nHerdIndex, nFlag)
	-- �ְ� ������ ������ �´�
	--local nMaxUserLevel	= classDoppelgangerLua:LuaGetMaxUserLevel()
	-- ������ �̿� ������ Hp�� ���
	--local nMonsterHp = nMaxUserLevel --* 10
	-- ���ӽ��� �� �����ð� (�и�������)
	local nPlayTime = nCurTime - nStateTime
	-- �ʹ�ȣ
	local nMapNumber = classDoppelgangerLua:LuaGetMapNumber()

	-- ���� ���ݷ� (�ּҰ��·� = nMonsterAtt * 0.8)
	--local nMonsterAtt 	= nMaxUserLevel + 100
	-- ���� ����
	--local nMonsterDef 	= nMaxUserLevel + 100

	local nMonsterIndex = 529	-- ������
	local nAttackFirst	= 0
	classDoppelgangerLua:LuaAddMonsterHerd(nHerdIndex, nMonsterIndex, nAttackFirst)

	if nFlag == 1 then
		nMonsterIndex 	= 538	-- ��ũ�ε�
		nAttackFirst	= 1
		classDoppelgangerLua:LuaAddMonsterHerd(nHerdIndex, nMonsterIndex, nAttackFirst)
	end
end

--//////////////////////////////////////////////////////////////////////////////
-- ���̽���Ŀ���� �߰��Ѵ�
--//////////////////////////////////////////////////////////////////////////////
function FN_LuaAddIceWorkerMonster(ncurTime, nStateTime, nHerdIndex)
	-- �ְ� ������ ������ �´�
	--local nMaxUserLevel	= classDoppelgangerLua:LuaGetMaxUserLevel()
	-- ������ �̿� ������ Hp�� ���
	--local nMonsterHp = nMaxUserLevel * 10

	-- ���� ���ݷ� (�ּҰ��·� = nMonsterAtt * 0.8)
	--local nMonsterAtt 	= nMaxUserLevel + 100
	-- ���� ����
	--local nMonsterDef 	= nMaxUserLevel + 100

	local nMonsterIndex = 531	-- ���̽���Ŀ
	local nAttackFirst	= 1

	local nMonsterCount = classDoppelgangerLua:LuaGetUserCount()
	for cnt = 0, nMonsterCount-1 do
		classDoppelgangerLua:LuaAddMonsterHerd(nHerdIndex, nMonsterIndex, nAttackFirst)
	end
end

--//////////////////////////////////////////////////////////////////////////////
-- ������ ������ġ�� �����´� ( ��ȯ���� �ΰ�)
--//////////////////////////////////////////////////////////////////////////////
function FN_LuaGetStartPosition(nMapNumber)
	local StartPosX = nill
	local StartPosY = nill

	if nMapNumber == 65 then
		StartPosX = 225
		StartPosY = 101
	elseif nMapNumber == 66 then
		StartPosX = 114
		StartPosY = 181
	elseif nMapNumber ==67 then
		StartPosX = 110
		StartPosY = 151
	elseif nMapNumber == 68 then
		StartPosX = 43
		StartPosY = 109
	end

	return StartPosX, StartPosY
end

--//////////////////////////////////////////////////////////////////////////////
-- ������ ������ġ�� �����´� ( ��ȯ���� �ΰ�)
--//////////////////////////////////////////////////////////////////////////////
function FN_LuaGetEndPosition(nMapNumber)
	local EndPosX = nill
	local EndPosY = nill

	if nMapNumber == 65 then
		EndPosX = 210
		EndPosY = 64
	elseif nMapNumber == 66 then
		EndPosX = 125
		EndPosY = 124
	elseif nMapNumber == 67 then
		EndPosX = 108
		EndPosY = 104
	elseif nMapNumber == 68 then
		EndPosX = 74
		EndPosY = 53
	end

	return EndPosX, EndPosY
end

--//////////////////////////////////////////////////////////////////////////////
-- ���̽���Ŀ�� ������ġ�� �����´� ( ��ȯ���� �ΰ�)
--//////////////////////////////////////////////////////////////////////////////
function FN_LuaGetIceWorkerStartPos(nMapNumber)
	local StartPosX = nill
	local StartPosY = nill

	if nMapNumber == 65 then
		StartPosX = 210
		StartPosY = 64
	elseif nMapNumber == 66 then
		StartPosX = 125
		StartPosY = 124
	elseif nMapNumber ==67 then
		StartPosX = 108
		StartPosY = 104
	elseif nMapNumber == 68 then
		StartPosX = 74
		StartPosY = 53
	end

	return StartPosX, StartPosY
end

















