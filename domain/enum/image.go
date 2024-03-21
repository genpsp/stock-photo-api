package enum

type ImageApprovalStatus int

const (
	PENDING ImageApprovalStatus = iota
	APPROVED
	REJECTED
)

func (e ImageApprovalStatus) Value() EnumValue {
	switch e {
	case PENDING:
		return EnumValue{0, "pending"}
	case APPROVED:
		return EnumValue{1, "approved"}
	case REJECTED:
		return EnumValue{2, "rejected"}
	default:
		return EnumValue{0, "pending"}
	}
}

func ImageApprovalStatuses() []EnumValue {
	return []EnumValue{
		PENDING.Value(),
		APPROVED.Value(),
		REJECTED.Value(),
	}
}

type EnumValue struct {
	Index int
	Name  string
}
